# Use CloudAMQP over MQTT from PHP

A minimal example of publishing and subscribing over MQTT 3.1.1 with
[php-mqtt/client](https://github.com/php-mqtt/client), against
[CloudAMQP](https://www.cloudamqp.com) or any MQTT-enabled broker such as
[LavinMQ](https://lavinmq.com) or RabbitMQ with the MQTT plugin.

- [`publisher.php`](publisher.php) publishes with QoS 1 and waits for the broker's PUBACK.
- [`worker.php`](worker.php) subscribes with QoS 1. php-mqtt/client acks each
  message before calling the handler.

## Usage

Requires PHP 8.4+ and [Composer](https://getcomposer.org). The version used in
development is in `mise.toml`. The MQTT details are on your instance's details
page in the CloudAMQP console; port 8883 uses TLS.

```sh
composer install
export MQTT_HOST=host.cloudamqp.com MQTT_PORT=8883 MQTT_USERNAME=vhost:user MQTT_PASSWORD=password
php worker.php      # in one terminal
php publisher.php   # in another
```

Without them it connects to `localhost:1883` as `guest`.

## Tests

`composer test` runs the worker and the publisher against a broker on
localhost, and checks that the message arrives. CI runs it against LavinMQ.
