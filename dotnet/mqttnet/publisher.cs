#:package MQTTnet@5.2.0.1603
using MQTTnet;
using MQTTnet.Formatter;
using MQTTnet.Protocol;

var port = int.Parse(Environment.GetEnvironmentVariable("MQTT_PORT") ?? "1883");
var options = new MqttClientOptionsBuilder()
    .WithTcpServer(Environment.GetEnvironmentVariable("MQTT_HOST") ?? "localhost", port)
    .WithCredentials(Environment.GetEnvironmentVariable("MQTT_USERNAME") ?? "guest", Environment.GetEnvironmentVariable("MQTT_PASSWORD") ?? "guest")
    .WithTlsOptions(tls => tls.UseTls(port == 8883))
    // MQTTnet defaults to MQTT 5, LavinMQ supports MQTT 3.1.1
    .WithProtocolVersion(MqttProtocolVersion.V311)
    .Build();
using var client = new MqttClientFactory().CreateMqttClient();
await client.ConnectAsync(options);

// QoS 1 completes once the broker has sent its PUBACK
await client.PublishStringAsync("hello", "Hello world!", MqttQualityOfServiceLevel.AtLeastOnce);
Console.WriteLine(" [x] Sent 'Hello world!'");
await client.DisconnectAsync();
