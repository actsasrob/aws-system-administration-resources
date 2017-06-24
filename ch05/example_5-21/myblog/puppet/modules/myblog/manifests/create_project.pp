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

  # Create celerytasks app directory structure
  exec { "init-celerytasks-app":
    command => "/usr/bin/python manage.py startapp ${myblog::tasks_app_name}",
    user => "mezzanine",
    cwd => $myblog::app_path,
    refreshonly => true,
  }

  # Install Celery app config module
  file { "${myblog::app_path}/${myblog::tasks_app_name}/apps.py":
    ensure  => file,
    owner => "mezzanine",
    group => "mezzanine",
    source  => "puppet:///modules/myblog/celeryapps.py",
  }

  # Install Celery tasks module
  file { "${myblog::app_path}/${myblog::tasks_app_name}/tasks.py":
    ensure  => file,
    owner => "mezzanine",
    group => "mezzanine",
    source  => "puppet:///modules/myblog/celerytasks.py",
  }

  file { "${myblog::app_path}/${myblog::app_name}/local_settings.py":
    ensure => present,
    content => template("myblog/local_settings.py.erb"),
    owner => "mezzanine",
    group => "mezzanine",
    require => Exec["init-mezzanine-project"],
    notify => Exec["init-mezzanine-db"]
  }

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

  # Install myblog celery module
  file { "${myblog::app_path}/${myblog::app_name}/_celery.py":
    ensure  => file,
    owner => "mezzanine",
    group => "mezzanine",
    source  => "puppet:///modules/myblog/_celery.py",
  }

  # Install myblog python module init script
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

}
