# myblogtasks/__init__.py

from __future__ import absolute_import

default_app_config = 'myblog.apps.MyblogConfig'

from ._celery import app as celery_app # noqa
