# Use CloudAMQP over MQTT from Rust

A minimal example of publishing and subscribing over MQTT 3.1.1 with
[rumqttc](https://github.com/bytebeamio/rumqtt/tree/main/rumqttc)'s blocking
client, against [CloudAMQP](https://www.cloudamqp.com) or any MQTT-enabled
broker such as [LavinMQ](https://lavinmq.com) or RabbitMQ with the MQTT plugin.

- [`publisher.rs`](src/bin/publisher.rs) publishes with QoS 1 and waits for the broker's PUBACK.
- [`worker.rs`](src/bin/worker.rs) subscribes with QoS 1. rumqttc acks each message
  as it arrives.

## Usage

Tool versions are in `mise.toml`; install them with [mise](https://mise.jdx.dev),
or use stable Rust. The MQTT details are on your instance's details page in the
CloudAMQP console; port 8883 uses TLS.

```sh
export MQTT_HOST=host.cloudamqp.com MQTT_PORT=8883 MQTT_USERNAME=vhost:user MQTT_PASSWORD=password
cargo run --bin worker      # in one terminal
cargo run --bin publisher   # in another
```

Without them it connects to `localhost:1883` as `guest`.

## Tests

`cargo test` runs the worker and the publisher against a broker on localhost,
and checks that the message arrives. CI runs it against LavinMQ.
