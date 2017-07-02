
class myblog::web {
  include  myblog::create_project,myblog
  Class['myblog'] -> Class['myblog::create_project'] -> Class['myblog::web']

  include myblog::mynginx

  # Daemonize the Django/Mezzanine processes
  supervisord::program { 'myblog_web':
    command             => "/usr/bin/python ${myblog::app_path}/manage.py runserver",
    priority            => '100',
    autostart           => true,
    autorestart         => true,
    ensure              => present,
    ensure_process      => 'running',
    user                => 'mezzanine',
  }

}
