# myblog/apps.py
# -*- coding: utf-8
from __future__ import unicode_literals
from django.apps import AppConfig

from mezzanine.generic.models import ThreadedComment
from django.db.models.signals import post_save
from django.utils.translation import ugettext_lazy as _

from myblog.tasks import process_comment
from myblog.tasks import process_comment_nocelery

class MyblogConfig(AppConfig):
    name = 'myblog'
    verbose_name = 'Myblog'

#    def ready(self):
#        post_save.connect(process_comment, sender=ThreadedComment)
#        post_save.connect(process_comment_nocelery, sender=ThreadedComment)

print "here in myblog/apps.py"
