import queue

from celery.contrib.testing.worker import start_worker
from celery.signals import task_success

from tasks import app, hello


def test_worker_runs_published_task():
    results = queue.Queue()

    def on_success(sender, result, **kwargs):
        results.put(result)

    task_success.connect(on_success, weak=False)
    try:
        # An embedded worker using the settings from celeryconfig.py
        with start_worker(app, pool="solo", perform_ping_check=False):
            hello.delay("CloudAMQP")
            assert results.get(timeout=10) == "Hello CloudAMQP!"
    finally:
        task_success.disconnect(on_success)
