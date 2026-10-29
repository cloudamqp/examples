# Use CloudAMQP over MQTT from .NET

A minimal example of publishing and subscribing over MQTT 3.1.1 with
[MQTTnet](https://github.com/dotnet/MQTTnet) 5, against
[CloudAMQP](https://www.cloudamqp.com) or any MQTT-enabled broker such as
[LavinMQ](https://lavinmq.com) or RabbitMQ with the MQTT plugin.

- [`publisher.cs`](publisher.cs) publishes with QoS 1 and waits for the broker's PUBACK.
- [`worker.cs`](worker.cs) subscribes with QoS 1, acking each message when the handler completes.

Both are [file-based apps](https://learn.microsoft.com/dotnet/core/sdk/file-based-apps):
`dotnet run` restores the MQTTnet package their `#:package` line names.

## Usage

Tool versions are in `mise.toml`; install them with [mise](https://mise.jdx.dev),
or use the .NET 10 SDK. The MQTT details are on your instance's details page in
the CloudAMQP console; port 8883 uses TLS.

```sh
export MQTT_HOST=host.cloudamqp.com MQTT_PORT=8883 MQTT_USERNAME=vhost:user MQTT_PASSWORD=password
dotnet run worker.cs      # in one terminal
dotnet run publisher.cs   # in another
```

Without them it connects to `localhost:1883` as `guest`.

## Tests

`dotnet test --project Tests` runs the worker and the publisher against a
broker on localhost, and checks that the message arrives. CI runs it against
LavinMQ.
