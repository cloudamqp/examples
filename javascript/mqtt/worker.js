import mqtt from "mqtt"

const port = Number(process.env.MQTT_PORT || 1883)
const client = await mqtt.connectAsync({
  host: process.env.MQTT_HOST || "localhost",
  port,
  protocol: port === 8883 ? "mqtts" : "mqtt",
  username: process.env.MQTT_USERNAME || "guest",
  password: process.env.MQTT_PASSWORD || "guest",
})

// Each message is acked when the handler returns
client.on("message", (topic, message) => {
  console.log(` [x] Received '${message}'`)
})
await client.subscribeAsync("hello", { qos: 1 })
console.log(" [*] Waiting for messages. To exit press CTRL+C")
