# Use CloudAMQP over MQTT from Swift

A minimal example of publishing and subscribing over MQTT 3.1.1 with
[MQTT NIO](https://github.com/swift-server-community/mqtt-nio), against
[CloudAMQP](https://www.cloudamqp.com) or any MQTT-enabled broker such as
[LavinMQ](https://lavinmq.com) or RabbitMQ with the MQTT plugin. MQTT NIO runs
on iOS, macOS and Linux.

- [`Publisher.swift`](Sources/publisher/Publisher.swift) publishes with QoS 1 and waits for the broker's PUBACK.
- [`Worker.swift`](Sources/worker/Worker.swift) subscribes with QoS 1. MQTT NIO
  acks each message before passing it on.

## Usage

Tool versions are in `mise.toml`; install them with [mise](https://mise.jdx.dev),
or use Swift 6 or later. The MQTT details are on your instance's details page in
the CloudAMQP console; port 8883 uses TLS.

```sh
export MQTT_HOST=host.cloudamqp.com MQTT_PORT=8883 MQTT_USERNAME=vhost:user MQTT_PASSWORD=password
swift run worker      # in one terminal
swift run publisher   # in another
```

Without them it connects to `localhost:1883` as `guest`.

## Tests

`swift test` runs the worker and the publisher against a broker on
localhost, and checks that the message arrives. CI runs it against LavinMQ.
