require "minitest/autorun"
require_relative "../connection"

class ConnectionTest < Minitest::Test
  def test_amqps_url_becomes_mqtts_with_vhost_in_username
    options = Connection.options("amqps://user:secret@host.cloudamqp.com/vhost")

    assert_equal({ host: "host.cloudamqp.com", port: 8883, ssl: true,
                   username: "vhost:user", password: "secret" }, options)
  end

  def test_amqp_url_becomes_plain_mqtt
    options = Connection.options("amqp://user:secret@localhost/vhost")

    assert_equal 1883, options[:port]
    assert_equal false, options[:ssl]
  end

  def test_default_vhost_is_left_out_of_username
    assert_equal "guest", Connection.options("amqp://guest:guest@localhost")[:username]
    assert_equal "guest", Connection.options("amqp://guest:guest@localhost/")[:username]
    assert_equal "guest", Connection.options("amqp://guest:guest@localhost/%2f")[:username]
  end

  def test_url_encoded_parts_are_decoded
    options = Connection.options("amqp://us%40er:p%2Fss@localhost/my%2Fvhost")

    assert_equal "my/vhost:us@er", options[:username]
    assert_equal "p/ss", options[:password]
  end
end
