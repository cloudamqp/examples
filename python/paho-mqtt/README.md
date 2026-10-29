# Use CloudAMQP over MQTT from Python

A minimal example of publishing and subscribing over MQTT 3.1.1 with
[paho-mqtt](https://github.com/eclipse-paho/paho.mqtt.python), against
[CloudAMQP](https://www.cloudamqp.com) or any MQTT-enabled broker such as
[LavinMQ](https://lavinmq.com) or RabbitMQ with the MQTT plugin.

- [`publisher.py`](publisher.py) publishes with QoS 1 and waits for the broker's PUBACK.
- [`worker.py`](worker.py) subscribes with QoS 1, acking each message when `on_message` returns.

## Usage

Tool versions are in `mise.toml`; with [mise](https://mise.jdx.dev) a virtualenv
is created in `.venv` automatically. Otherwise use Python 3 and a virtualenv.
The MQTT details are on your instance's details page in the CloudAMQP console;
port 8883 uses TLS.

```sh
pip install -r requirements.txt
export MQTT_HOST=host.cloudamqp.com MQTT_PORT=8883 MQTT_USERNAME=vhost:user MQTT_PASSWORD=password
python worker.py      # in one terminal
python publisher.py   # in another
```

Without them it connects to `localhost:1883` as `guest`.

## Tests

`pytest` runs the worker and the publisher against a broker on localhost, and
checks that the message arrives. CI runs it against LavinMQ.

```sh
pip install -r requirements-dev.txt
pytest
```
