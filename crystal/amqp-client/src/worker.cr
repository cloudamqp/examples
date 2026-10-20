require "./example"

conn = Example.connect
Example.consume(conn.channel, "hello") { |message| puts " [x] Received '#{message}'" }
puts " [*] Waiting for messages. To exit press CTRL+C"

Process.on_terminate do
  conn.close
  exit
end
sleep
