# Use CloudAMQP over MQTT from Ruby

A minimal example of publishing and subscribing over MQTT 3.1.1 with
[ruby-mqtt](https://github.com/njh/ruby-mqtt), against
[CloudAMQP](https://www.cloudamqp.com) or any MQTT-enabled broker such as
[LavinMQ](https://lavinmq.com) or RabbitMQ with the MQTT plugin.

- [`publisher.rb`](publisher.rb) publishes with QoS 1 and waits for the broker's PUBACK.
- [`worker.rb`](worker.rb) subscribes with QoS 1, acking each message when the block returns.
- [`connection.rb`](connection.rb) connects using the `BROKER_URL` environment variable.
  It's the same AMQP URL as the other examples: `amqps://` becomes MQTT over TLS on
  port 8883, `amqp://` plain MQTT on port 1883, and the vhost goes in the username as
  `vhost:user`.

## Usage

Tool versions are in `mise.toml`; install them with [mise](https://mise.jdx.dev),
or use any maintained Ruby version.

```sh
bundle install
export BROKER_URL="amqps://user:password@host/vhost"
bundle exec ruby worker.rb      # in one terminal
bundle exec ruby publisher.rb   # in another
```

Without `BROKER_URL` it connects to `amqp://guest:guest@localhost`, which
becomes `mqtt://localhost:1883` as user `guest`.

## Tests

`bundle exec rake` tests the URL conversion, and publishes and receives a
message through a real broker on localhost. CI runs it against LavinMQ.
