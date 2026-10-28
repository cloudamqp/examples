# Use CloudAMQP over MQTT from Arduino

A minimal example of publishing and subscribing over MQTT 3.1.1 with
[PubSubClient](https://github.com/knolleary/pubsubclient) on an ESP32, against
[CloudAMQP](https://www.cloudamqp.com) or any MQTT-enabled broker such as
[LavinMQ](https://lavinmq.com) or RabbitMQ with the MQTT plugin.

- [`publisher.ino`](publisher/publisher.ino) publishes a message. PubSubClient can
  only publish with QoS 0, so the broker doesn't confirm it.
- [`worker.ino`](worker/worker.ino) subscribes with QoS 1, acking each message
  when the callback returns.

Both connect over TLS on port 8883 and verify the server certificate against
the CA certificates built into the ESP32 core, with `useBuiltinCACertBundle()`.

Unlike most examples here, this one isn't run in CI, as it needs an ESP32. CI
compiles both sketches.

## Usage

Set your WiFi network and the MQTT details from your instance's details page in
the CloudAMQP console at the top of both sketches. Then, with
[arduino-cli](https://arduino.github.io/arduino-cli/) (its version is in
`mise.toml`), compile and upload each one with the board and library versions
in its `sketch.yaml`:

```sh
arduino-cli compile --profile esp32 --upload --port /dev/ttyUSB0 worker
arduino-cli monitor --port /dev/ttyUSB0 --config baudrate=115200
arduino-cli compile --profile esp32 --upload --port /dev/ttyUSB1 publisher
```

In the Arduino IDE, install the esp32 board package and the PubSubClient
library, open a sketch and upload it.
