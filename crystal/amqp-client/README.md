# Use CloudAMQP from Crystal

A minimal example of publishing and consuming messages with
[amqp-client.cr](https://github.com/cloudamqp/amqp-client.cr), against
[CloudAMQP](https://www.cloudamqp.com) or any AMQP 0-9-1 broker such as
[LavinMQ](https://lavinmq.com) or RabbitMQ.

All AMQP code is in [`src/example.cr`](src/example.cr):

- `publish` publishes a persistent message and blocks until the broker has
  confirmed it. amqp-client.cr publishes transient messages unless
  `delivery_mode: 2` is set.
- `consume` consumes with a prefetch of 10, acking each message after the
  block returns. `subscribe` acks automatically unless `no_ack: false` is
  passed.
- `connect` connects using the `CLOUDAMQP_URL` environment variable, and
  verifies the server certificate for `amqps://` URLs.

amqp-client.cr doesn't reconnect: if the connection is lost, the programs exit.

## Usage

Tool versions are in `mise.toml`; install them with [mise](https://mise.jdx.dev),
or use any Crystal 1.x.

```sh
shards build
export CLOUDAMQP_URL="amqps://user:password@host/vhost"
bin/worker      # in one terminal
bin/publisher   # in another
```

Without `CLOUDAMQP_URL` it connects to `amqp://guest:guest@localhost`.

## Tests

`crystal spec` publishes and consumes a message through a real broker on
localhost. CI runs it against LavinMQ, together with `crystal tool format` and
[ameba](https://github.com/crystal-ameba/ameba).
