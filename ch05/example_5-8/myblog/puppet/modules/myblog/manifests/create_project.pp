class myblog::create_project {
  notify { 'mezzanine_project_name':
     message => "mezzine project name: ${myblog::app_path}",
  }

  # Create the Mezzanine project
  exec { "init-mezzanine-project":
    command => "/usr/local/bin/mezzanine-project ${myblog::app_path}",
    user => "mezzanine",
    creates => "${myblog::app_path}/__init__.py",
    notify => Exec["init-mezzanine-db"],
  }

  # Create the development SQLite database
  exec { "init-mezzanine-db":
    command => "/usr/bin/python manage.py createdb --noinput",
    user => "mezzanine",
    cwd => $myblog::app_path,
    refreshonly => true,
  }
}
