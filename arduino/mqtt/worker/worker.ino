#include <MQTT.h>
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
MQTTClient mqtt;

// Each QoS 1 message is acked when the callback returns
void onMessage(String& topic, String& payload) {
  Serial.printf(" [x] Received '%s'\n", payload.c_str());
}

void setup() {
  Serial.begin(115200);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  while (WiFi.status() != WL_CONNECTED) delay(500);

  // Verify the server against the CA certificates built into the ESP32 core
  secureClient.useBuiltinCACertBundle();
  mqtt.begin(MQTT_HOST, MQTT_PORT, MQTT_PORT == 8883 ? static_cast<Client&>(secureClient) : plainClient);
  mqtt.onMessage(onMessage);
  if (!mqtt.connect(("worker-" + WiFi.macAddress()).c_str(), MQTT_USERNAME, MQTT_PASSWORD)) {
    Serial.printf("Connection failed: %d\n", mqtt.lastError());
    return;
  }
  mqtt.subscribe("hello", 1);
  Serial.println(" [*] Waiting for messages");
}

void loop() {
  mqtt.loop();
}
