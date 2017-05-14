BROKER_URL = 'sqs://your-aws-access-key:your-aws-access-secret@'
BROKER_TRANSPORT_OPTIONS = {'region': 'eu-west-1'}
CELERY_IMPORTS = ('tasks')

INSTALLED_APPS = (
      "django.contrib.admin",
   "django.contrib.auth",
   "django.contrib.contenttypes",
   "django.contrib.redirects",
   "django.contrib.sessions",
   "django.contrib.sites",
   "django.contrib.sitemaps",
   "django.contrib.staticfiles",
   "mezzanine.boot",
   "mezzanine.conf",
   "mezzanine.core",
   "mezzanine.generic",
   "mezzanine.blog",
   "mezzanine.forms",
   "mezzanine.pages",
   "mezzanine.galleries",
   "mezzanine.twitter",
#"mezzanine.accounts",
#"mezzanine.mobile",
   "djcelery",
)
