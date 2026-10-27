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

client.subscribe("hello" => 1)
puts " [*] Waiting for messages. To exit press CTRL+C"
# Each message is acked when the block returns
client.get do |_topic, message|
  puts " [x] Received '#{message}'"
end
