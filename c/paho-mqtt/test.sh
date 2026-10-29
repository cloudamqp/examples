#!/bin/sh
# Runs the worker and the publisher as a reader would, and checks that the
# message arrives
set -eu

output=$(mktemp)
trap 'kill "$worker" 2>/dev/null; rm -f "$output"' EXIT
./worker > "$output" &
worker=$!

wait_for() {
  for _ in $(seq 50); do
    grep -q "$1" "$output" && return 0
    sleep 0.1
  done
  echo "Worker didn't print \"$1\":" >&2
  cat "$output" >&2
  exit 1
}

wait_for "Waiting for messages"
./publisher
wait_for "Received 'Hello world!'"
echo "ok"
