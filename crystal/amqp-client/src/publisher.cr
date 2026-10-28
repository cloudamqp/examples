require "./example"

conn = Example.connect
Example.publish(conn.channel, "hello", "Hello world!")
conn.close
