# Use CloudAMQP over MQTT from C

A minimal example of publishing and subscribing over MQTT 3.1.1 with the
[Eclipse Paho C client](https://github.com/eclipse-paho/paho.mqtt.c)'s
synchronous API, against [CloudAMQP](https://www.cloudamqp.com) or any
MQTT-enabled broker such as [LavinMQ](https://lavinmq.com) or RabbitMQ with
the MQTT plugin.

- [`publisher.c`](publisher.c) publishes with QoS 1 and waits for the broker's PUBACK.
- [`worker.c`](worker.c) subscribes with QoS 1. Paho C acks each message as it
  arrives.

## Usage

Install the Paho C library, `libpaho-mqtt-dev` on Debian and Ubuntu, and build
with `make`; there are no other tools to pin, so there's no `mise.toml`. The
MQTT details are on your instance's details page in the CloudAMQP console;
port 8883 uses TLS, verified against the system's certificates.

```sh
make
export MQTT_HOST=host.cloudamqp.com MQTT_PORT=8883 MQTT_USERNAME=vhost:user MQTT_PASSWORD=password
./worker      # in one terminal
./publisher   # in another
```

Without them it connects to `localhost:1883` as `guest`.

## Tests

`make test` runs the worker and the publisher against a broker on localhost,
and checks that the message arrives. CI runs it against LavinMQ.
