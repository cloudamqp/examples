require "spec"
require "../src/example"

describe Example do
  it "delivers a published message to the worker" do
    queue = "roundtrip-#{Random::Secure.hex(8)}"
    received = Channel(String).new(1)
    conn = Example.connect

    begin
      Example.consume(conn.channel, queue) { |message| received.send(message) }
      Example.publish(conn.channel, queue, "Hello CloudAMQP!")

      select
      when message = received.receive
        message.should eq "Hello CloudAMQP!"
      when timeout(5.seconds)
        fail "no message received"
      end
    ensure
      conn.channel.queue_delete(queue)
      conn.close
    end
  end
end
