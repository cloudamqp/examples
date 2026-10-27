require "mqtt"

port = Integer(ENV.fetch("MQTT_PORT", "1883"))
client = MQTT::Client.new(
  host: ENV.fetch("MQTT_HOST", "localhost"),
  port: port,
  ssl: port == 8883,
  username: ENV.fetch("MQTT_USERNAME", "guest"),
  password: ENV.fetch("MQTT_PASSWORD", "guest")
)
# ruby-mqtt only checks the certificate's hostname, not who signed it
client.ssl_context.set_params(verify_mode: OpenSSL::SSL::VERIFY_PEER)
client.connect

# QoS 1 waits for the broker's PUBACK
client.publish("hello", "Hello world!", false, 1)
puts " [x] Sent 'Hello world!'"
client.disconnect
