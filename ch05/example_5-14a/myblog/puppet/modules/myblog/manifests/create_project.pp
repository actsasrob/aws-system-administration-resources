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

  #file { "${myblog::app_path}/${myblog::app_name}/local_settings.py":
  #  ensure => present,
  #  content => template("myblog/local_settings.py.erb"),
  #  owner => "mezzanine",
  #  group => "mezzanine",
  #  require => Exec["init-mezzanine-project"],
  #  notify => Exec["init-mezzanine-db"]
  #}

  file_line { 'local_settingspy_allowed_hosts':
    path  => "${myblog::app_path}/${myblog::app_name}/local_settings.py",
    line => 'ALLOWED_HOSTS = "*"',
    match  => '# ALLOWED_HOSTS = \[""\]',
    require => Exec["init-mezzanine-project"],
  }

  file_line { 'local_settingspy_name':
    path  => "${myblog::app_path}/${myblog::app_name}/local_settings.py",
    line => "       \"NAME\": \"mydb\",",
    match  => '^*"NAME":',
    require => Exec["init-mezzanine-project"],
    notify => Exec["init-mezzanine-db"]
  }

  file_line { 'local_settingspy_engine':
    path  => "${myblog::app_path}/${myblog::app_name}/local_settings.py",
    line => "       \"ENGINE\": \"django.db.backends.mysql\",",
    match  => '^*"ENGINE":',
    require => Exec["init-mezzanine-project"],
    notify => Exec["init-mezzanine-db"]
  }

  file_line { 'local_settingspy_user':
    path  => "${myblog::app_path}/${myblog::app_name}/local_settings.py",
    line => "        \"USER\": \"${myblog::db_user}\",",
    match  => '^*"USER:"',
    require => Exec["init-mezzanine-project"],
    notify => Exec["init-mezzanine-db"]
  }

  file_line { 'local_settingspy_password':
    path  => "${myblog::app_path}/${myblog::app_name}/local_settings.py",
    line => "        \"PASSWORD\": \"${myblog::db_password}\",",
    match  => '^*"PASSWORD:"',
    require => Exec["init-mezzanine-project"],
    notify => Exec["init-mezzanine-db"]
  }

  file_line { 'local_settingspy_host':
    path  => "${myblog::app_path}/${myblog::app_name}/local_settings.py",
    line => "        \"HOST\": \"${myblog::db_endpoint}\",",
    match  => '^*"HOST:"',
    require => Exec["init-mezzanine-project"],
    notify => Exec["init-mezzanine-db"]
  }

  # Create the development SQLite database
  exec { "init-mezzanine-db":
    command => "/usr/bin/python manage.py createdb --noinput",
    user => "mezzanine",
    cwd => $myblog::app_path,
    refreshonly => true,
  }
}
