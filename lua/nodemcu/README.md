# Use CloudAMQP over MQTT from NodeMCU

A minimal example of publishing and subscribing over MQTT 3.1.1 with the
[NodeMCU mqtt module](https://nodemcu.readthedocs.io/en/release/modules/mqtt/),
on an ESP8266 or ESP32, against [CloudAMQP](https://www.cloudamqp.com) or any
MQTT-enabled broker such as [LavinMQ](https://lavinmq.com) or RabbitMQ with the
MQTT plugin.

- [`publisher.lua`](publisher.lua) publishes with QoS 1 and waits for the broker's PUBACK.
- [`worker.lua`](worker.lua) subscribes with QoS 1.

Unlike the other examples, this one isn't tested in CI, as it needs NodeMCU
firmware to run.

## Usage

Build a firmware with the `mqtt`, `wifi` and `node` modules, and `tls` for port
8883, for example with the [NodeMCU custom build service](https://nodemcu-build.com).
Set the MQTT details from your instance's details page in the CloudAMQP console
at the top of both files, upload them with a tool such as
[nodemcu-tool](https://github.com/AndiDittrich/NodeMCU-Tool), connect to WiFi,
and run:

```lua
dofile("worker.lua")      -- on one device
dofile("publisher.lua")   -- on another
```

On port 8883 the connection is encrypted, but NodeMCU only verifies the server
certificate once you've loaded a CA certificate with
[`tls.cert.verify()`](https://nodemcu.readthedocs.io/en/release/modules/tls/#tlscertverify).
