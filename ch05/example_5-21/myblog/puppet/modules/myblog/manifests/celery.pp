
class myblog::celery {
  include  myblog::create_project,myblog
  Class['myblog'] -> Class['myblog::create_project'] -> Class['myblog::celery']

  # Daemonize the Celery worker processes
  supervisord::program { 'myblog_celery':
    command             => "celery -A ${myblog::app_name} worker -l debug -Q celery",
    priority            => '100',
    autostart           => true,
    autorestart         => true,
    ensure              => present,
    ensure_process      => 'running',
    user                => 'mezzanine',
    directory           => "${myblog::app_path}",
  }

}
