from celery import Celery
from django.dispatch import receiver
from django.db.models.signals import post_save
from mezzanine.generic.models import ThreadedComment

app = Celery('tasks', broker='amqp://guest@localhost//')

def is_comment_spam(comment):
    # This check is just an example!
    if "spam" in comment.comment:
        return True
    
@app.task
def process_comment_async(comment):
    print "Processing comment"
    if is_comment_spam(comment):
        # The comment is spam, so hide it
        ThreadedComment.objects.filter(id=comment.id).update(is_public=False)
        
@receiver(post_save, sender=ThreadedComment)
def process_comment(sender, **kwargs):
    process_comment_async.delay(kwargs['instance'])
