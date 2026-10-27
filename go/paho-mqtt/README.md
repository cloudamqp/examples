# Use CloudAMQP over MQTT from Go

A minimal example of publishing and subscribing over MQTT 3.1.1 with
[paho.mqtt.golang](https://github.com/eclipse-paho/paho.mqtt.golang), against
[CloudAMQP](https://www.cloudamqp.com) or any MQTT-enabled broker such as
[LavinMQ](https://lavinmq.com) or RabbitMQ with the MQTT plugin.

- [`publisher/main.go`](publisher/main.go) publishes with QoS 1 and waits for the broker's PUBACK.
- [`worker/main.go`](worker/main.go) subscribes with QoS 1, acking each message when the handler returns.

## Usage

Tool versions are in `mise.toml`; install them with [mise](https://mise.jdx.dev),
or use Go 1.24 or later. The MQTT details are on your instance's details page in
the CloudAMQP console; port 8883 uses TLS.

```sh
export MQTT_HOST=host.cloudamqp.com MQTT_PORT=8883 MQTT_USERNAME=vhost:user MQTT_PASSWORD=password
go run ./worker      # in one terminal
go run ./publisher   # in another
```

Without them it connects to `localhost:1883` as `guest`.

## Tests

`go test ./...` runs the worker and the publisher against a broker on
localhost, and checks that the message arrives. CI runs it against LavinMQ.
