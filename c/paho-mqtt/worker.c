#include <MQTTClient.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

static const char* env(const char* name, const char* fallback) {
  const char* value = getenv(name);
  return value ? value : fallback;
}

int main(void) {
  // Print each line straight away, also when the output isn't a terminal
  setvbuf(stdout, NULL, _IOLBF, 0);
  const char* port = env("MQTT_PORT", "1883");
  int tls = strcmp(port, "8883") == 0;
  char uri[256];
  snprintf(uri, sizeof uri, "%s://%s:%s", tls ? "ssl" : "tcp", env("MQTT_HOST", "localhost"), port);
  char client_id[32];
  snprintf(client_id, sizeof client_id, "worker-%d", (int)getpid());

  MQTTClient client;
  MQTTClient_create(&client, uri, client_id, MQTTCLIENT_PERSISTENCE_NONE, NULL);
  MQTTClient_connectOptions options = MQTTClient_connectOptions_initializer;
  options.username = env("MQTT_USERNAME", "guest");
  options.password = env("MQTT_PASSWORD", "guest");
  MQTTClient_SSLOptions ssl = MQTTClient_SSLOptions_initializer;
  ssl.verify = 1;  // Paho C checks the certificate, but not its hostname, by default
  if (tls) options.ssl = &ssl;
  int rc = MQTTClient_connect(client, &options);
  if (rc != MQTTCLIENT_SUCCESS) {
    fprintf(stderr, "Connection failed: %s\n", MQTTClient_strerror(rc));
    return 1;
  }

  MQTTClient_subscribe(client, "hello", 1);
  printf(" [*] Waiting for messages. To exit press CTRL+C\n");
  // Paho C acks each QoS 1 message as it arrives
  for (;;) {
    char* topic;
    int topic_length;
    MQTTClient_message* message;
    rc = MQTTClient_receive(client, &topic, &topic_length, &message, 1000);
    if (rc != MQTTCLIENT_SUCCESS) {
      fprintf(stderr, "Connection lost: %s\n", MQTTClient_strerror(rc));
      return 1;
    }
    if (message) {
      printf(" [x] Received '%.*s'\n", message->payloadlen, (char*)message->payload);
      MQTTClient_freeMessage(&message);
      MQTTClient_free(topic);
    }
  }
}
