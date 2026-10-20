import os

# Recommended settings for CloudAMQP, see https://www.cloudamqp.com/docs/celery.html
broker_url = os.environ.get("CLOUDAMQP_URL", "amqp://guest:guest@localhost//")
broker_pool_limit = 1  # Decreases connection usage
broker_heartbeat = None  # CloudAMQP uses TCP keep-alive instead
broker_connection_timeout = 30  # Long timeout, e.g. for slow DNS lookups
result_backend = None  # Don't store results in the broker
event_queue_expires = 60  # Delete celeryev queues without consumers after a minute
worker_prefetch_multiplier = 1  # Fetch one message at a time
worker_concurrency = 50  # For I/O-bound tasks; for CPU-bound tasks, use the number of cores
