require_relative "connection"

module Worker
  def self.subscribe(client, topic)
    client.subscribe(topic => 1)
  end

  # Each message is acked when the block returns
  def self.consume(client, &handler)
    client.get { |_topic, payload| handler.call(payload) }
  end
end

if __FILE__ == $PROGRAM_NAME
  client = Connection.client
  Worker.subscribe(client, "hello")
  puts " [*] Waiting for messages. To exit press CTRL+C"
  begin
    Worker.consume(client) { |message| puts " [x] Received #{message.inspect}" }
  rescue Interrupt
    client.disconnect
  end
end
