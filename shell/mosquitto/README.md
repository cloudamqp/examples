# Use CloudAMQP over MQTT from the command line

A minimal example of publishing and subscribing over MQTT 3.1.1 with
[mosquitto_pub](https://mosquitto.org/man/mosquitto_pub-1.html) and
[mosquitto_sub](https://mosquitto.org/man/mosquitto_sub-1.html), against
[CloudAMQP](https://www.cloudamqp.com) or any MQTT-enabled broker such as
[LavinMQ](https://lavinmq.com) or RabbitMQ with the MQTT plugin. Handy for
checking a connection or watching a topic.

- [`publisher.sh`](publisher.sh) publishes with QoS 1 and waits for the broker's PUBACK.
- [`worker.sh`](worker.sh) subscribes with QoS 1 and prints each message.

## Usage

Install the Mosquitto clients, `mosquitto-clients` on Debian and Ubuntu or
`mosquitto` with Homebrew; there are no other tools to pin, so there's no
`mise.toml`. The MQTT details are on your instance's details page in the
CloudAMQP console; port 8883 uses TLS, verified against the system's
certificates.

```sh
export MQTT_HOST=host.cloudamqp.com MQTT_PORT=8883 MQTT_USERNAME=vhost:user MQTT_PASSWORD=password
./worker.sh      # in one terminal
./publisher.sh   # in another
```

Without them it connects to `localhost:1883` as `guest`.

## Tests

`./test.sh` runs the worker and the publisher against a broker on localhost,
and checks that the message arrives. CI runs it against LavinMQ.
