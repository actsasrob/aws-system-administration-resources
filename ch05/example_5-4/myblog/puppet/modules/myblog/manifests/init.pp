class myblog {
  $app_name = "myblog"
  $app_path = "/srv/${app_name}"

  # Move this declaration to requirements.pp as supervisord as it requires python-pip package
  #class {"supervisord":
  #  install_init => true,
  #}

  include myblog::requirements
}
