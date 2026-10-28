require "amqp-client"

module Amqp
  def self.client
    AMQP::Client.new(ENV.fetch("BROKER_URL", "amqp://guest:guest@localhost")).start
  end
end
