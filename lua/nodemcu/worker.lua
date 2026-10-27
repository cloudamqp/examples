-- The MQTT details from your instance's details page in the CloudAMQP console
local MQTT_HOST = "host.cloudamqp.com"
local MQTT_PORT = 8883 -- TLS
local MQTT_USERNAME = "vhost:user"
local MQTT_PASSWORD = "password"

local client = mqtt.Client("worker-" .. node.chipid(), 120, MQTT_USERNAME, MQTT_PASSWORD)
client:on("message", function(_, _, message)
  print(" [x] Received '" .. message .. "'")
end)
client:connect(MQTT_HOST, MQTT_PORT, MQTT_PORT == 8883, function()
  client:subscribe("hello", 1, function()
    print(" [*] Waiting for messages")
  end)
end, function(_, reason)
  print("Connection failed: " .. reason)
end)
