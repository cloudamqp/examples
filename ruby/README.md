# Use CloudAMQP from Ruby

A minimal example of publishing and consuming messages with
[amqp-client.rb](https://github.com/cloudamqp/amqp-client.rb), against
[CloudAMQP](https://www.cloudamqp.com) or any AMQP 0-9-1 broker such as
[LavinMQ](https://lavinmq.com) or RabbitMQ.

- [`publisher.rb`](publisher.rb) publishes a message; it's persistent and waits for a publisher confirm by default.
- [`worker.rb`](worker.rb) consumes with a prefetch of 10, acking each message when the block returns.
- [`amqp.rb`](amqp.rb) connects using the `CLOUDAMQP_URL` environment variable, and reconnects automatically.

## Usage

Tool versions are in `mise.toml`; install them with [mise](https://mise.jdx.dev),
or use any maintained Ruby version.

```sh
bundle install
export CLOUDAMQP_URL="amqps://user:password@host/vhost"
bundle exec ruby worker.rb      # in one terminal
bundle exec ruby publisher.rb   # in another
```

Without `CLOUDAMQP_URL` it connects to `amqp://guest:guest@localhost`.

## Tests

`bundle exec rake` publishes and consumes a message through a real broker on
localhost. CI runs it against LavinMQ.
