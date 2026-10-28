require "mqtt"
require "uri"

module Connection
  def self.client
    MQTT::Client.connect(options(ENV.fetch("BROKER_URL", "amqp://guest:guest@localhost")))
  end

  # Uses the same URL as the AMQP examples. MQTT has no vhost, so it goes in
  # the username as "vhost:user"
  def self.options(amqp_url)
    uri = URI(amqp_url)
    ssl = uri.scheme == "amqps"
    user = URI.decode_uri_component(uri.user || "guest")
    vhost = URI.decode_uri_component(uri.path.delete_prefix("/"))
    {
      host: uri.host,
      port: ssl ? 8883 : 1883,
      ssl: ssl,
      username: ["", "/"].include?(vhost) ? user : "#{vhost}:#{user}",
      password: URI.decode_uri_component(uri.password || "guest")
    }
  end
end
