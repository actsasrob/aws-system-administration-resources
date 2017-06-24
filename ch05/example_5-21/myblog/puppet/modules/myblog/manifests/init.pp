class myblog (
  $db_endpoint, $db_user, $db_password
) {
  $app_name = "myblog"
  $app_path = "/srv/${app_name}"
  $tasks_app_name = "celerytasks"

  # Move this declaration to requirements.pp as supervisord as it requires python-pip package
  #class {"supervisord":
  #  install_init => true,
  #}

  include myblog::requirements
}
