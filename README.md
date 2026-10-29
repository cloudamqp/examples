# CloudAMQP examples

Minimal examples of connecting to [CloudAMQP](https://www.cloudamqp.com), or any
AMQP 0-9-1 broker such as [LavinMQ](https://lavinmq.com) or RabbitMQ. Examples are
grouped by language, then by client library or framework. Each folder is a
self-contained project with its own README.

| Language | Example | Protocol | Description |
|---|---|---|---|
| Arduino | [arduino/pubsubclient](arduino/pubsubclient) | MQTT | Publish/subscribe on an ESP32 with [PubSubClient](https://github.com/knolleary/pubsubclient), compiled but not run in CI |
| C | [c/paho-mqtt](c/paho-mqtt) | MQTT | QoS 1 publish/subscribe with [Eclipse Paho C](https://github.com/eclipse-paho/paho.mqtt.c) |
| Clojure | [clojure/langohr](clojure/langohr) | AMQP | Publish/consume with [Langohr](https://github.com/michaelklishin/langohr) |
| Crystal | [crystal/amqp-client](crystal/amqp-client) | AMQP | Publish/consume with [amqp-client.cr](https://github.com/cloudamqp/amqp-client.cr) |
| .NET | [dotnet/mqttnet](dotnet/mqttnet) | MQTT | QoS 1 publish/subscribe with [MQTTnet](https://github.com/dotnet/MQTTnet) 5 |
| .NET | [dotnet/rabbitmq-client](dotnet/rabbitmq-client) | AMQP | Publish/consume with the [RabbitMQ .NET client](https://github.com/rabbitmq/rabbitmq-dotnet-client) 7 |
| Go | [go/amqp-client](go/amqp-client) | AMQP | Publish/consume with [amqp-client.go](https://github.com/cloudamqp/amqp-client.go) |
| Go | [go/paho-mqtt](go/paho-mqtt) | MQTT | QoS 1 publish/subscribe with [paho.mqtt.golang](https://github.com/eclipse-paho/paho.mqtt.golang) |
| Java | [java/paho-mqtt](java/paho-mqtt) | MQTT | QoS 1 publish/subscribe with [Eclipse Paho](https://github.com/eclipse-paho/paho.mqtt.java) |
| Java | [java/rabbitmq-client](java/rabbitmq-client) | AMQP | Publish/consume with the [RabbitMQ Java client](https://github.com/rabbitmq/rabbitmq-java-client) |
| JavaScript | [javascript/amqp-client](javascript/amqp-client) | AMQP | Publish/consume with [amqp-client.js](https://github.com/cloudamqp/amqp-client.js) |
| JavaScript | [javascript/mqtt](javascript/mqtt) | MQTT | QoS 1 publish/subscribe with [MQTT.js](https://github.com/mqttjs/MQTT.js) |
| Lua | [lua/nodemcu](lua/nodemcu) | MQTT | QoS 1 publish/subscribe on [NodeMCU](https://nodemcu.readthedocs.io), not tested in CI |
| PHP | [php/php-amqplib](php/php-amqplib) | AMQP | Publish/consume with [php-amqplib](https://github.com/php-amqplib/php-amqplib) |
| PHP | [php/php-mqtt-client](php/php-mqtt-client) | MQTT | QoS 1 publish/subscribe with [php-mqtt/client](https://github.com/php-mqtt/client) |
| Python | [python/celery](python/celery) | AMQP | [Celery](https://docs.celeryq.dev) app using CloudAMQP as the broker |
| Python | [python/paho-mqtt](python/paho-mqtt) | MQTT | QoS 1 publish/subscribe with [paho-mqtt](https://github.com/eclipse-paho/paho.mqtt.python) |
| Python | [python/pika](python/pika) | AMQP | Publish/consume with [Pika](https://github.com/pika/pika) |
| Ruby | [ruby/amqp-client](ruby/amqp-client) | AMQP | Publish/consume with [amqp-client.rb](https://github.com/cloudamqp/amqp-client.rb) |
| Ruby | [ruby/mqtt](ruby/mqtt) | MQTT | QoS 1 publish/subscribe with [ruby-mqtt](https://github.com/njh/ruby-mqtt) |
| Rust | [rust/amqp-client](rust/amqp-client) | AMQP | Publish/consume with [amqp-client.rs](https://github.com/cloudamqp/amqp-client.rs) |
| Rust | [rust/rumqttc](rust/rumqttc) | MQTT | QoS 1 publish/subscribe with [rumqttc](https://github.com/bytebeamio/rumqtt) |
| Shell | [shell/mosquitto](shell/mosquitto) | MQTT | QoS 1 publish/subscribe with [mosquitto_pub and mosquitto_sub](https://mosquitto.org) |
| Swift | [swift/mqttnio](swift/mqttnio) | MQTT | QoS 1 publish/subscribe with [MQTT NIO](https://github.com/swift-server-community/mqtt-nio) |
| TypeScript | [typescript/amqp-client](typescript/amqp-client) | AMQP | Publish/consume with [amqp-client.js](https://github.com/cloudamqp/amqp-client.js) |
