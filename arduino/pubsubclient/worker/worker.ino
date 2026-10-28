#include <PubSubClient.h>
#include <WiFi.h>
#include <WiFiClientSecure.h>

const char* WIFI_SSID = "your-wifi";
const char* WIFI_PASSWORD = "your-wifi-password";
// The MQTT details from your instance's details page in the CloudAMQP console
const char* MQTT_HOST = "host.cloudamqp.com";
const int MQTT_PORT = 8883;  // TLS
const char* MQTT_USERNAME = "vhost:user";
const char* MQTT_PASSWORD = "password";

WiFiClientSecure secureClient;
WiFiClient plainClient;
PubSubClient mqtt(MQTT_PORT == 8883 ? static_cast<Client&>(secureClient) : plainClient);

// PubSubClient acks each QoS 1 message when the callback returns
void onMessage(char* topic, byte* payload, unsigned int length) {
  Serial.printf(" [x] Received '%.*s'\n", length, (char*)payload);
}

void setup() {
  Serial.begin(115200);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  while (WiFi.status() != WL_CONNECTED) delay(500);

  // Verify the server against the CA certificates built into the ESP32 core
  secureClient.useBuiltinCACertBundle();
  mqtt.setServer(MQTT_HOST, MQTT_PORT);
  mqtt.setCallback(onMessage);
  if (!mqtt.connect(("worker-" + WiFi.macAddress()).c_str(), MQTT_USERNAME, MQTT_PASSWORD)) {
    Serial.printf("Connection failed: %d\n", mqtt.state());
    return;
  }
  mqtt.subscribe("hello", 1);
  Serial.println(" [*] Waiting for messages");
}

void loop() {
  mqtt.loop();
}
