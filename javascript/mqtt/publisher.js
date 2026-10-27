import mqtt from "mqtt"

const port = Number(process.env.MQTT_PORT || 1883)
const client = await mqtt.connectAsync({
  host: process.env.MQTT_HOST || "localhost",
  port,
  protocol: port === 8883 ? "mqtts" : "mqtt",
  username: process.env.MQTT_USERNAME || "guest",
  password: process.env.MQTT_PASSWORD || "guest",
})

// QoS 1 resolves once the broker has sent its PUBACK
await client.publishAsync("hello", "Hello world!", { qos: 1 })
console.log(" [x] Sent 'Hello world!'")
await client.endAsync()
