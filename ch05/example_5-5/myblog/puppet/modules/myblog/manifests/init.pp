include myblog::requirements

class myblog {
  $app_path = "/srv/myblog"
  class {"supervisord": 
    install_init => true
  }
}
