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
  const char* port = env("MQTT_PORT", "1883");
  int tls = strcmp(port, "8883") == 0;
  char uri[256];
  snprintf(uri, sizeof uri, "%s://%s:%s", tls ? "ssl" : "tcp", env("MQTT_HOST", "localhost"), port);
  char client_id[32];
  snprintf(client_id, sizeof client_id, "publisher-%d", (int)getpid());

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

  // QoS 1, and waitForCompletion waits for the broker's PUBACK
  const char* message = "Hello world!";
  MQTTClient_deliveryToken token;
  MQTTClient_publish(client, "hello", (int)strlen(message), message, 1, 0, &token);
  rc = MQTTClient_waitForCompletion(client, token, 10000);
  if (rc != MQTTCLIENT_SUCCESS) {
    fprintf(stderr, "Publish failed: %s\n", MQTTClient_strerror(rc));
    return 1;
  }
  printf(" [x] Sent '%s'\n", message);

  MQTTClient_disconnect(client, 1000);
  MQTTClient_destroy(&client);
  return 0;
}
