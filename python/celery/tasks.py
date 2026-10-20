from celery import Celery
from celery.utils.log import get_task_logger

app = Celery("tasks")
app.config_from_object("celeryconfig")
logger = get_task_logger(__name__)


@app.task
def hello(name):
    message = f"Hello {name}!"
    logger.info(message)
    return message
