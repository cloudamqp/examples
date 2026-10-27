-- The MQTT details from your instance's details page in the CloudAMQP console
local MQTT_HOST = "host.cloudamqp.com"
local MQTT_PORT = 8883 -- TLS
local MQTT_USERNAME = "vhost:user"
local MQTT_PASSWORD = "password"

local client = mqtt.Client("publisher-" .. node.chipid(), 120, MQTT_USERNAME, MQTT_PASSWORD)
client:connect(MQTT_HOST, MQTT_PORT, MQTT_PORT == 8883, function()
  -- QoS 1, and the callback runs once the broker has sent its PUBACK
  client:publish("hello", "Hello world!", 1, 0, function()
    print(" [x] Sent 'Hello world!'")
    client:close()
  end)
end, function(_, reason)
  print("Connection failed: " .. reason)
end)
