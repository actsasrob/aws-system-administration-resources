class myblog {
  $app_name = "myblog"
  $app_path = "/srv/${app_name}"

  class {"supervisord": 
    install_init => true
  }

  include myblog::requirements
}
