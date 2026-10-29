# Use CloudAMQP over MQTT from JavaScript

A minimal example of publishing and subscribing over MQTT 3.1.1 with
[MQTT.js](https://github.com/mqttjs/MQTT.js), against
[CloudAMQP](https://www.cloudamqp.com) or any MQTT-enabled broker such as
[LavinMQ](https://lavinmq.com) or RabbitMQ with the MQTT plugin.

- [`publisher.js`](publisher.js) publishes with QoS 1 and waits for the broker's PUBACK.
- [`worker.js`](worker.js) subscribes with QoS 1, acking each message when the handler returns.

## Usage

Tool versions are in `mise.toml`; install them with [mise](https://mise.jdx.dev),
or use Node.js 24.2 or later. The MQTT details are on your instance's details
page in the CloudAMQP console; port 8883 uses TLS.

```sh
npm install
export MQTT_HOST=host.cloudamqp.com MQTT_PORT=8883 MQTT_USERNAME=vhost:user MQTT_PASSWORD=password
node worker.js      # in one terminal
node publisher.js   # in another
```

Without them it connects to `localhost:1883` as `guest`.

## Tests

`npm test` runs the worker and the publisher against a broker on localhost,
and checks that the message arrives. CI runs it against LavinMQ.
