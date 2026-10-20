require "minitest/autorun"
require "securerandom"
require_relative "../connection"
require_relative "../publisher"
require_relative "../worker"

class RoundtripTest < Minitest::Test
  # Subscribe and publish on one connection, so the broker has handled the
  # subscribe before the publish arrives
  def test_worker_receives_published_message
    topic = "roundtrip/#{SecureRandom.uuid}"
    received = Queue.new
    client = Connection.client

    Worker.subscribe(client, topic)
    Publisher.publish(client, topic, "Hello CloudAMQP!")
    thread = Thread.new { Worker.consume(client) { |message| received << message } }

    assert_equal "Hello CloudAMQP!", received.pop(timeout: 5)
  ensure
    thread&.kill
    client&.disconnect
  end
end
