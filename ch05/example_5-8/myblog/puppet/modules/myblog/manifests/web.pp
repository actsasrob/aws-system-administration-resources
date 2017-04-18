#include myblog::mynginx

class myblog::web {
  Class["myblog::web"] -> Class["myblog"]
  include myblog::mynginx
  supervisor::service { "myblog_web":
    ensure => present,
    enable => true,
    command => "/usr/bin/python ${myblog::app_path}/manage.py runserver",
    user => "mezzanine",
    group => "mezzanine"
  }
}
