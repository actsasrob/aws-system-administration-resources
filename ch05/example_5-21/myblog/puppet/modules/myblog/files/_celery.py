from __future__ import absolute_import

import os

from celery import Celery

from django.conf import settings  # noqa

from kombu import Exchange, Queue

# set the default Django settings module for the 'celery' program.
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'myblog.settings')

app = Celery('myblog')

# Using a string here means the worker will not have to
# pickle the object when using Windows.
app.config_from_object('django.conf:settings')

app.conf.task_queues = (
    Queue('default', Exchange('default'), routing_key='default'),
)
app.conf.task_default_queue = 'default'
app.conf.task_default_exchange_type = 'direct'
app.conf.task_default_routing_key = 'default'
#app.conf.task_default_queue = 'celeryqueue'
#app.autodiscover_tasks(lambda: settings.INSTALLED_APPS)

