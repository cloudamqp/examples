#!/bin/sh
set -eu

port=${MQTT_PORT:-1883}
# Port 8883 uses TLS, verified against the system's certificates
[ "$port" = 8883 ] && set -- --tls-use-os-certs

# QoS 1 waits for the broker's PUBACK
mosquitto_pub "$@" -h "${MQTT_HOST:-localhost}" -p "$port" \
  -u "${MQTT_USERNAME:-guest}" -P "${MQTT_PASSWORD:-guest}" \
  -q 1 -t hello -m "Hello world!"
echo " [x] Sent 'Hello world!'"
