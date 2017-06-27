from __future__ import unicode_literals

from django.apps import AppConfig

# This import is needed for the tasks module to be loaded
from celerytasks.tasks import process_comment

class CeleryTasksConfig(AppConfig):
    name = 'celerytasks'

    def ready(self):
        pass
