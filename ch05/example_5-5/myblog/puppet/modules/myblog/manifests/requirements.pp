class myblog::requirements {
  $packages = ["python-dev", "python-pip", "libjpeg8", "libjpeg8-dev", "libtiff5-dev", "zlib1g-dev", "libfreetype6-dev", "python-imaging", "python-mysqldb"] 
  package { $packages:
    ensure => installed
  }

  $pip_packages = ["Mezzanine", "python-memcached"]
  package { $pip_packages:
    ensure => installed,
    provider => pip,
    require => Package[$packages]
  }

  user { "mezzanine":
    ensure => present
  }

  file { "${myblog::app_path}":
    ensure => "directory",
    owner => "mezzanine",
    group => "mezzanine"
  }
}
