node default {
  $userdata = parsejson($ec2_userdata)

  # Set variables from userdata
  $role = $userdata['role']
  case $role {
    "web": { $role_class = "myblog::web" }
    default: { fail("Unrecognized role: $role") }
  }

  # Main myblog class
  class { "myblog":
  }

  # Role-specific class, e.g. myblog::web
  class { $role_class:
  }
}
