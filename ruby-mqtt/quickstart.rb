require 'mqtt'

mqtturl = 'mqtts://rwgvqgbl:dt4yLbbvJd6FYQjVhyhBpvKROz2PUMXc@test-tall-gold-lark.rmq3.cloudamqp.com/rwgvqgbl'

# Publish example
puts "Sending"
MQTT::Client.connect(mqtturl) do |c|
  c.publish('topic', 'message')
end

puts 'Subscribing'
# Subscribe example
MQTT::Client.connect(mqtturl) do |c|
  c.subscribe('topic') do |topic, message|
    puts "#{topic}: #{message}"
  end
end

Thread.new do
  MQTT::Client.connect(mqtturl) do |c|
    c.subscribe('topic') do |t, message|
      puts "#{t}: #{message}"
    end
  end
end
