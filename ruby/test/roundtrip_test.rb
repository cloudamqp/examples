require "minitest/autorun"
require "securerandom"
require_relative "../amqp"
require_relative "../publisher"
require_relative "../worker"

class RoundtripTest < Minitest::Test
  def test_worker_receives_published_message
    queue = "roundtrip-#{SecureRandom.uuid}"
    received = Queue.new
    client = Amqp.client

    Worker.consume(client, queue) { |message| received << message }
    Publisher.publish(client, queue, "Hello CloudAMQP!")

    assert_equal "Hello CloudAMQP!", received.pop(timeout: 5)
  ensure
    client&.queue(queue)&.delete
    client&.stop
  end
end
