from __future__ import absolute_import

from celery import shared_task

from django.dispatch import receiver
from django.db.models.signals import post_save

# Cannot import an external app model here without getting the dreaded 'django.core.exceptions.AppRegistryNotReady: Apps aren't loaded yet' error message
#from mezzanine.generic.models import ThreadedComment

def is_comment_spam(threadedcomment):
    # This check is just an example!
    if "spam" in threadedcomment.comment:
        return True

@shared_task
def process_comment_async(threadedcomment):
    from mezzanine.generic.models import ThreadedComment
    if isinstance(threadedcomment, ThreadedComment):  
        if is_comment_spam(threadedcomment):
            ThreadedComment.objects.filter(id=threadedcomment.id).update(is_public=False)

#@receiver(post_save, sender=ThreadedComment)
@receiver(post_save, sender=None)
def process_comment(sender, **kwargs):
    process_comment_async.delay(kwargs['instance'])

