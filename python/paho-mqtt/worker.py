import os

import paho.mqtt.client as mqtt


def on_subscribe(client, userdata, mid, reason_codes, properties):
    print(" [*] Waiting for messages. To exit press CTRL+C")


# Each message is acked when on_message returns
def on_message(client, userdata, message):
    print(f" [x] Received '{message.payload.decode()}'")


port = int(os.environ.get("MQTT_PORT", "1883"))
client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
client.username_pw_set(os.environ.get("MQTT_USERNAME", "guest"), os.environ.get("MQTT_PASSWORD", "guest"))
if port == 8883:
    client.tls_set()
client.on_subscribe = on_subscribe
client.on_message = on_message
client.connect(os.environ.get("MQTT_HOST", "localhost"), port)
client.subscribe("hello", qos=1)
try:
    client.loop_forever()
except KeyboardInterrupt:
    client.disconnect()
