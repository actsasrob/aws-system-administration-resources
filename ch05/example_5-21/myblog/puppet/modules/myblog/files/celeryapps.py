from __future__ import unicode_literals

from django.apps import AppConfig

class CeleryTasksConfig(AppConfig):
    name = 'celerytasks'

    def ready(self):
        pass
