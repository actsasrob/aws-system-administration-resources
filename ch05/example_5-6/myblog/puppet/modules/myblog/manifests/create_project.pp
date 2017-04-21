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

  file_line { 'settingspy_allowed_hosts':
    path  => "${myblog::app_path}/${myblog::app_name}/settings.py", 
    line => 'ALLOWD_HOSTS = "*"',
    match  => 'ALLOWED_HOSTS = []',
  }

  # Create the development SQLite database
  exec { "init-mezzanine-db":
    command => "/usr/bin/python manage.py createdb --noinput",
    user => "mezzanine",
    cwd => $myblog::app_path,
    refreshonly => true,
  }
}
