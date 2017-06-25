class myblog::create_project {
  include myblog

  notify { 'mezzanine_project_info':
     message => "mezzine project name: ${myblog::app_name} project dir: ${myblog::app_path}",
  }

  # Create the Mezzanine project
  exec { "init-mezzanine-project":
    command => "/usr/local/bin/mezzanine-project ${myblog::app_name} ${myblog::app_path}",
    user => "mezzanine",
    creates => "${myblog::app_path}/__init__.py",
    notify => Exec["init-mezzanine-db"],
  }
 
  # Install the Django local_settings.py config file
  file { "${myblog::app_path}/${myblog::app_name}/local_settings.py":
    ensure => present,
    content => template("myblog/local_settings.py.erb"),
    owner => "mezzanine",
    group => "mezzanine",
    require => Exec["init-mezzanine-project"],
    notify => Exec["init-mezzanine-db"]
  }

  # Update the local_settings.py config file to allow non-local access to web application
  file_line { 'settingspy_allowed_hosts':
    path  => "${myblog::app_path}/${myblog::app_name}/settings.py",
    line => 'ALLOWED_HOSTS = "*"',
    match  => 'ALLOWED_HOSTS = \[\]',
    require => Exec["init-mezzanine-project"],
  }

  # Install myblog app config module
  file { "${myblog::app_path}/${myblog::app_name}/apps.py":
    ensure  => file,
    owner => "mezzanine",
    group => "mezzanine",
    source  => "puppet:///modules/myblog/myblogapps.py",
  }

  # Install myblog celery module which initializes Celery
  file { "${myblog::app_path}/${myblog::app_name}/_celery.py":
    ensure  => file,
    owner => "mezzanine",
    group => "mezzanine",
    source  => "puppet:///modules/myblog/_celery.py",
  }

  # Install myblog python module init script which forces the _celery.py module to be loaded at application start
  file { "${myblog::app_path}/${myblog::app_name}/__init__.py":
    ensure  => file,
    owner => "mezzanine",
    group => "mezzanine",
    source  => "puppet:///modules/myblog/__init__.py",
  }

  # Create the database
  exec { "init-mezzanine-db":
    command => "/usr/bin/python manage.py createdb --noinput",
    user => "mezzanine",
    cwd => $myblog::app_path,
    refreshonly => true,
  }

  # Create a reusable Django app named celerytasks containing the shared Celery tasks and Django post_save signal handlers
  exec { "init-celerytasks-app":
    command => "/usr/bin/python manage.py startapp ${myblog::tasks_app_name}",
    creates => "${myblog::app_path}/${myblog::tasks_app_name}",
    user => "mezzanine",
    cwd => $myblog::app_path,
  }

  # Install celerytasks app config module. Allows celerytasks app to be loaded at application start via the INSTALLED_APPS list in local_settings.py
  file { "${myblog::app_path}/${myblog::tasks_app_name}/apps.py":
    ensure  => file,
    owner => "mezzanine",
    group => "mezzanine",
    source  => "puppet:///modules/myblog/celeryapps.py",
  }

  # Install Celery tasks module containing shared Celery task(s)
  file { "${myblog::app_path}/${myblog::tasks_app_name}/tasks.py":
    ensure  => file,
    owner => "mezzanine",
    group => "mezzanine",
    source  => "puppet:///modules/myblog/tasks.py",
  }

  # Enable the celerytasks.apps.CeleryTasksConfig entry in local_settings.py.
  # Keep in mind the 'python manage.py' commands read the project local_settings.py file.
  # The celerytasks app config cannot be enabaled in INSTALLED_APPS in local_settings.py until all the necessary
  # files have been added to the celerytasks directory otherwise it breaks the 'python manage.py' command.
  file_line { 'uncomment-line-in-local-settings':
    path    => "${myblog::app_path}/${myblog::app_name}/local_settings.py",
    line    => '   "celerytasks.apps.CeleryTasksConfig",',
    match   => '^#  "celerytasks.apps.CeleryTasksConfig",$',
  }
}
