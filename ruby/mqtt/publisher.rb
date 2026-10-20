require_relative "connection"

module Publisher
  # QoS 1 waits for the broker's PUBACK
  def self.publish(client, topic, message)
    client.publish(topic, message, false, 1)
    puts " [x] Sent #{message.inspect}"
  end
end

if __FILE__ == $PROGRAM_NAME
  client = Connection.client
  Publisher.publish(client, "hello", "Hello CloudAMQP!")
  client.disconnect
end
