import static java.nio.charset.StandardCharsets.UTF_8;

import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttConnectOptions;
import org.eclipse.paho.client.mqttv3.persist.MemoryPersistence;

public class Worker {
  public static void main(String[] args) throws Exception {
    String port = System.getenv().getOrDefault("MQTT_PORT", "1883");
    String scheme = port.equals("8883") ? "ssl" : "tcp";
    String host = System.getenv().getOrDefault("MQTT_HOST", "localhost");
    MqttConnectOptions options = new MqttConnectOptions();
    options.setUserName(System.getenv().getOrDefault("MQTT_USERNAME", "guest"));
    options.setPassword(System.getenv().getOrDefault("MQTT_PASSWORD", "guest").toCharArray());

    MqttClient client = new MqttClient(scheme + "://" + host + ":" + port, MqttClient.generateClientId(), new MemoryPersistence());
    client.connect(options);
    // Each message is acked when the listener returns
    client.subscribe("hello", 1, (topic, message) ->
        System.out.println(" [x] Received '" + new String(message.getPayload(), UTF_8) + "'"));
    System.out.println(" [*] Waiting for messages. To exit press CTRL+C");
  }
}
