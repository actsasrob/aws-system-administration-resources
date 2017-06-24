from __future__ import unicode_literals

from django.apps import AppConfig

from django.db.models.signals import post_save

from celerytasks.tasks import process_comment
#from celerytasks.tasks import process_comment_nocelery


class CeleryTasksConfig(AppConfig):
    name = 'celerytasks'

    def ready(self):
        from mezzanine.blog.models import BlogPost
        #post_save.connect(process_comment, sender=None)
        #post_save.connect(process_comment, sender=BlogPost)
        #post_save.connect(process_comment_nocelery, sender=None)


