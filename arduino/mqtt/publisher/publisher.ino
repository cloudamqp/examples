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

void setup() {
  Serial.begin(115200);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  while (WiFi.status() != WL_CONNECTED) delay(500);

  // Verify the server against the CA certificates built into the ESP32 core
  secureClient.useBuiltinCACertBundle();
  mqtt.begin(MQTT_HOST, MQTT_PORT, MQTT_PORT == 8883 ? static_cast<Client&>(secureClient) : plainClient);
  if (!mqtt.connect(("publisher-" + WiFi.macAddress()).c_str(), MQTT_USERNAME, MQTT_PASSWORD)) {
    Serial.printf("Connection failed: %d\n", mqtt.lastError());
    return;
  }

  // With QoS 1, publish returns once the broker has confirmed the message
  if (mqtt.publish("hello", "Hello world!", false, 1)) {
    Serial.println(" [x] Sent 'Hello world!'");
  } else {
    Serial.printf("Publish failed: %d\n", mqtt.lastError());
  }
  mqtt.disconnect();
}

void loop() {}
