import os

import paho.mqtt.client as mqtt

port = int(os.environ.get("MQTT_PORT", "1883"))
client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
client.username_pw_set(os.environ.get("MQTT_USERNAME", "guest"), os.environ.get("MQTT_PASSWORD", "guest"))
if port == 8883:
    client.tls_set()
client.connect(os.environ.get("MQTT_HOST", "localhost"), port)
client.loop_start()

# QoS 1 waits for the broker's PUBACK
client.publish("hello", "Hello world!", qos=1).wait_for_publish()
print(" [x] Sent 'Hello world!'")
client.disconnect()
client.loop_stop()
