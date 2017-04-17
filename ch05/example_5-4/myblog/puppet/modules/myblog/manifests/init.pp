include myblog::requirements

class myblog {
  $app_path = "/srv/myblog"
  class {"supervisor": }
  #require myblog::requirements
}
