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

  # Create the database
  exec { "init-mezzanine-db":
    command => "/usr/bin/python manage.py createdb --noinput",
    user => "mezzanine",
    cwd => $myblog::app_path,
    refreshonly => true,
  }
 
  # Install Celery task
  file { "${myblog::app_path}/tasks.py":
    ensure  => file,
    owner => "mezzanine",
    group => "mezzanine",
    source  => "puppet:///modules/myblog/tasks.py",
  }
}
