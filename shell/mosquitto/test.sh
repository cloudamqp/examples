#!/bin/sh
# Runs the worker and the publisher as a reader would, and checks that the
# message arrives. mosquitto_sub doesn't say when it has subscribed, so this
# publishes once a second until the worker prints the message
set -eu

output=$(mktemp)
trap 'kill "$worker" 2>/dev/null; rm -f "$output"' EXIT
./worker.sh > "$output" &
worker=$!

for _ in $(seq 10); do
  ./publisher.sh
  sleep 1
  if grep -q "Received 'Hello world!'" "$output"; then
    echo "ok"
    exit 0
  fi
done
echo "Worker didn't receive the message:" >&2
cat "$output" >&2
exit 1
