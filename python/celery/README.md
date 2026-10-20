# Use CloudAMQP with Celery

A minimal [Celery](https://docs.celeryq.dev) app using
[CloudAMQP](https://www.cloudamqp.com), or any AMQP 0-9-1 broker such as
[LavinMQ](https://lavinmq.com) or RabbitMQ, as the broker.

- [`celeryconfig.py`](celeryconfig.py) has the settings we recommend for
  CloudAMQP, explained in the [CloudAMQP Celery docs](https://www.cloudamqp.com/docs/celery.html).
- [`tasks.py`](tasks.py) defines a `hello` task.
- [`publisher.py`](publisher.py) sends it to the worker.

## Usage

Tool versions are in `mise.toml`; with [mise](https://mise.jdx.dev) a virtualenv
is created in `.venv` automatically. Otherwise use Python 3.9+ and a virtualenv.

```sh
pip install -r requirements.txt
export CLOUDAMQP_URL="amqps://user:password@host/vhost"
celery -A tasks worker --without-heartbeat --without-gossip --without-mingle   # in one terminal
python publisher.py                                                           # in another
```

The `--without-*` flags stop the worker from sending heartbeat, gossip and
mingle messages, which otherwise add up to hundreds of messages per second.

Without `CLOUDAMQP_URL` it connects to `amqp://guest:guest@localhost`.

## Tests

`pytest` starts an embedded worker with the settings in `celeryconfig.py`, and
runs a task through a real broker on localhost. CI runs it against LavinMQ.

```sh
pip install -r requirements-dev.txt
pytest
```
