#include myblog::mynginx

class myblog::web {
  include  myblog::create_project,myblog
  Class['myblog'] -> Class['myblog::create_project'] -> Class['myblog::web']

  include myblog::mynginx

  #supervisord::service { "myblog_web":
  #  ensure => present,
  #  enable => true,
  #  command => "/usr/bin/python ${myblog::app_path}/manage.py runserver",
  #  user => "mezzanine",
  #  group => "mezzanine"
  #}

  supervisord::program { 'myblog_web':
    command             => '/usr/bin/python ${myblog::app_path}/manage.py runserver',
    priority            => '100',
    autostart		=> true,
    autorestart		=> true,
    ensure		=> present,
    ensure_process	=> 'running',
    user		=> 'mezzanine',
  }

}
