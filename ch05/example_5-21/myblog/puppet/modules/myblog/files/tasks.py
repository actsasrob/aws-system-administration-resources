from __future__ import absolute_import

#import django
#django.setup()

from celery import shared_task

#from celery import Celery
from django.dispatch import receiver
from django.db.models.signals import post_save
#from mezzanine.generic.models import ThreadedComment
#from mezzanine.blog.models import BlogPost

import time

from celery.utils.log import get_task_logger

logger = get_task_logger(__name__)

def is_comment_spam(threadedcomment):
    # This check is just an example!
    print "got here: is_comment_spam..."
    #if "spam" in blogpost.title or "spam" in blogpost.content:
    if "spam" in threadedcomment.comment:
        return True

def print_keyword_args(**kwargs):
    # kwargs is a dict of the keyword args passed to the function
    for key, value in kwargs.iteritems():
        #print "%s = %s" % (key, value)
        logger = get_task_logger(__name__)
        logger.info('keyword_args: {0} + {1}'.format(key, value))

@shared_task
def process_comment_async(threadedcomment):
    #from mezzanine.blog.models import BlogPost
    from mezzanine.generic.models import ThreadedComment
    print "pca: here in process_comment_async" 
    print ("pca: here in process_comment_async repr %s" % repr(threadedcomment)) 
    now = time.strftime("%c")
    print ("pca: Current time %s"  % now )
    if isinstance(threadedcomment, ThreadedComment):  
        print ("pca: here in process_comment_async comment=%s" % threadedcomment.comment)
        if is_comment_spam(threadedcomment):
            print "pca: contains spam"
            # The blogpost contains is spam, so hide it
            #blogpost.status=1
            #blogpost.save()
            #BlogPost.objects.filter(id=blogpost.id).update(status=1) # Set status to "draft"
            ThreadedComment.objects.filter(id=threadedcomment.id).update(is_public=False)

#@receiver(post_save, sender=ThreadedComment)
#def process_comment(sender, **kwargs):
#    print "got here: process_comment"
#    process_comment_async.delay(kwargs['instance'])

#@receiver(post_save, sender=ThreadedComment)
@receiver(post_save, sender=None)
def process_comment(sender, **kwargs):
    print "pc: got here: process_comment"
    logger.info('pc: here in process_comment {0}'.format('blah'))
    logger.info('pc: here in process_comment sender={0}'.format(repr(sender)))
    print "pc: got here: process_comment"
    print "pc: got here: process_comment"
    print "pc: got here: process_comment"
    now = time.strftime("%c")
    print ("pc: Current time %s"  % now )
    print "pc: keyword args..."
    print_keyword_args(**kwargs)
    process_comment_async.delay(kwargs['instance'])

#@receiver(post_save, sender=ThreadedComment)
#@receiver(post_save, sender=None)
#def process_comment_noqueue(sender, **kwargs):
#    print "pcnq: here in process_comment_noqueue" 
#    logger.info('pcnq: here in process_comment_noqueue {0}'.format('blah'))
#    logger.info('pcnq: here in process_comment_noqueue sender={0}'.format(repr(sender)))
#    print "pcnq: here in process_comment_noqueue" 
#    now = time.strftime("%c")
#    print ("pcnq: Current time %s"  % now )
#    print "pcnq: keyword args..."
#    print_keyword_args(**kwargs)

#post_save.connect(process_comment, sender=None)
#post_save.connect(process_comment_nocelery, sender=None)
