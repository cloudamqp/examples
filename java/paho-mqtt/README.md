# Use CloudAMQP over MQTT from Java

A minimal example of publishing and subscribing over MQTT 3.1.1 with the
[Eclipse Paho Java client](https://github.com/eclipse-paho/paho.mqtt.java), against
[CloudAMQP](https://www.cloudamqp.com) or any MQTT-enabled broker such as
[LavinMQ](https://lavinmq.com) or RabbitMQ with the MQTT plugin.

- [`Publisher.java`](src/main/java/Publisher.java) publishes with QoS 1 and waits for the broker's PUBACK.
- [`Worker.java`](src/main/java/Worker.java) subscribes with QoS 1, acking each message when the listener returns.

## Usage

Tool versions are in `mise.toml`; install them with [mise](https://mise.jdx.dev),
or use Java 21+ and Maven 3. The MQTT details are on your instance's details
page in the CloudAMQP console; port 8883 uses TLS.

```sh
export MQTT_HOST=host.cloudamqp.com MQTT_PORT=8883 MQTT_USERNAME=vhost:user MQTT_PASSWORD=password
mvn compile exec:java -Dexec.mainClass=Worker      # in one terminal
mvn compile exec:java -Dexec.mainClass=Publisher   # in another
```

Without them it connects to `localhost:1883` as `guest`.

## Tests

`mvn test` runs the worker and the publisher against a broker on localhost,
and checks that the message arrives. CI runs it against LavinMQ.
