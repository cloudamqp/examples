#!/bin/sh
set -eu

port=${MQTT_PORT:-1883}
# Port 8883 uses TLS, verified against the system's certificates
[ "$port" = 8883 ] && set -- --tls-use-os-certs

# Subscribes with QoS 1, and prints each message until you press CTRL+C
exec mosquitto_sub "$@" -h "${MQTT_HOST:-localhost}" -p "$port" \
  -u "${MQTT_USERNAME:-guest}" -P "${MQTT_PASSWORD:-guest}" \
  -q 1 -t hello -F " [x] Received '%p'"
