# Use CloudAMQP over MQTT from Ruby

A minimal example of publishing and subscribing over MQTT 3.1.1 with
[ruby-mqtt](https://github.com/njh/ruby-mqtt), against
[CloudAMQP](https://www.cloudamqp.com) or any MQTT-enabled broker such as
[LavinMQ](https://lavinmq.com) or RabbitMQ with the MQTT plugin.

- [`publisher.rb`](publisher.rb) publishes with QoS 1 and waits for the broker's PUBACK.
- [`worker.rb`](worker.rb) subscribes with QoS 1, acking each message when the block returns.

## Usage

Tool versions are in `mise.toml`; install them with [mise](https://mise.jdx.dev),
or use any maintained Ruby version. The MQTT details are on your instance's
details page in the CloudAMQP console; port 8883 uses TLS.

```sh
bundle install
export MQTT_HOST=host.cloudamqp.com MQTT_PORT=8883 MQTT_USERNAME=vhost:user MQTT_PASSWORD=password
bundle exec ruby worker.rb      # in one terminal
bundle exec ruby publisher.rb   # in another
```

Without them it connects to `localhost:1883` as `guest`.

## Tests

`bundle exec rake` runs the worker and the publisher against a broker on
localhost, and checks that the message arrives. CI runs it against LavinMQ.
