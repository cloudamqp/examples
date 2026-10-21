require_relative "amqp"

module Publisher
  # Messages are persistent and wait for a publisher confirm by default
  def self.publish(client, queue, message)
    client.queue(queue).publish(message)
    puts " [x] Sent #{message.inspect}"
  end
end

if __FILE__ == $PROGRAM_NAME
  client = Amqp.client
  Publisher.publish(client, "hello", "Hello CloudAMQP!")
  client.stop
end
