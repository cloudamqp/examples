require_relative "amqp"

module Worker
  # The message is acked when the block returns, and requeued if it raises
  def self.consume(client, queue, &handler)
    client.queue(queue).subscribe(prefetch: 10) do |msg|
      handler.call(msg.body)
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  client = Amqp.client
  Worker.consume(client, "hello") { |message| puts " [x] Received #{message.inspect}" }
  puts " [*] Waiting for messages. To exit press CTRL+C"
  begin
    sleep
  rescue Interrupt
    client.stop
  end
end
