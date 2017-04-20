class myblog {
  $app_name = "myblog"
  $app_path = "/srv"

  class {"supervisord": 
    install_init => true
  }

  include myblog::requirements
}
