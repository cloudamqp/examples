import static java.nio.charset.StandardCharsets.UTF_8;

import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttConnectOptions;
import org.eclipse.paho.client.mqttv3.persist.MemoryPersistence;

public class Publisher {
  public static void main(String[] args) throws Exception {
    String port = System.getenv().getOrDefault("MQTT_PORT", "1883");
    String scheme = port.equals("8883") ? "ssl" : "tcp";
    String host = System.getenv().getOrDefault("MQTT_HOST", "localhost");
    MqttConnectOptions options = new MqttConnectOptions();
    options.setUserName(System.getenv().getOrDefault("MQTT_USERNAME", "guest"));
    options.setPassword(System.getenv().getOrDefault("MQTT_PASSWORD", "guest").toCharArray());

    try (MqttClient client = new MqttClient(scheme + "://" + host + ":" + port, MqttClient.generateClientId(), new MemoryPersistence())) {
      client.connect(options);
      // QoS 1 blocks until the broker has sent its PUBACK
      client.publish("hello", "Hello world!".getBytes(UTF_8), 1, false);
      System.out.println(" [x] Sent 'Hello world!'");
      client.disconnect();
    }
  }
}
