import os
import subprocess
import sys

# Runs the worker and the publisher as a reader would
def test_worker_receives_published_message():
    env = {**os.environ, "PYTHONUNBUFFERED": "1"}
    worker = subprocess.Popen([sys.executable, "worker.py"], stdout=subprocess.PIPE, text=True, env=env)
    try:
        assert "Waiting for messages" in worker.stdout.readline()
        subprocess.run([sys.executable, "publisher.py"], check=True, timeout=10)
        assert "Received 'Hello world!'" in worker.stdout.readline()
    finally:
        worker.kill()
