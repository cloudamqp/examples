import os

import pika


def connect():
    url = os.environ.get("BROKER_URL", "amqp://guest:guest@localhost/%2f")
    return pika.BlockingConnection(pika.URLParameters(url))
