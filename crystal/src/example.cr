require "amqp-client"

module Example
  # Connects to CLOUDAMQP_URL. TLS connections (amqps://) verify the server certificate.
  # The client doesn't reconnect: restart the process or reconnect yourself if the connection is lost.
  def self.connect : AMQP::Client::Connection
    AMQP::Client.new(ENV.fetch("CLOUDAMQP_URL", "amqp://guest:guest@localhost")).connect
  end

  # Publishes a persistent message and blocks until the broker has confirmed it
  def self.publish(ch : AMQP::Client::Channel, queue : String, message : String) : Nil
    q = ch.queue(queue, durable: true)
    props = AMQP::Client::Properties.new(content_type: "text/plain", delivery_mode: 2_u8)
    q.publish_confirm(message, props: props) || raise "Message was not confirmed"
    puts " [x] Sent '#{message}'"
  end

  # Consumes with a prefetch of 10, acking each message after the block returns
  def self.consume(ch : AMQP::Client::Channel, queue : String, &handler : String ->) : Nil
    ch.prefetch(10)
    ch.queue(queue, durable: true).subscribe(no_ack: false) do |msg|
      handler.call(msg.body_io.to_s)
      msg.ack
    end
  end
end
