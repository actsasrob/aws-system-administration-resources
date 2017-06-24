
class myblog::celery {
  include  myblog::create_project,myblog
  Class['myblog'] -> Class['myblog::create_project'] -> Class['myblog::celery']

  supervisord::program { 'myblog_celery':
    command             => "celery -A ${myblog::app_name} worker -l debug -Q celery",
    priority            => '105',
    autostart           => true,
    autorestart         => true,
    ensure              => present,
    ensure_process      => 'running',
    user                => 'mezzanine',
    program_environment => {
      'HOME'   => '${myblog::app_path}',
    }
  }

}
