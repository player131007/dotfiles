use std/config env-conversions
let path_like_vars = [
    XDG_DATA_DIRS
    XDG_CONFIG_DIRS
    XCURSOR_PATH
    TERMINFO_DIRS
    QT_PLUGIN_PATH
    QML2_IMPORT_PATH
    INFOPATH
    GTK_PATH
]
$env.ENV_CONVERSIONS = $env.ENV_CONVERSIONS | merge ($path_like_vars | each { append (env-conversions).path } | into record) | merge {
  NIX_PATH: {
    from_string: { |s|
      $s | split row ":" | each { |s|
        let s = split row "=" --number 2
        if ($s | length) == 1 {
          {prefix: "", path: $s.0}
        } else {prefix: $s.0, path: $s.1}
      }
    }

    to_string: { |v| $v | each {|v|
      if $v.prefix == "" {
        $v.path
      } else $"($v.prefix)=($v.path)"
    } | str join ":"
    }
  }
}
$env.config.show_banner = false
$env.config.history.file_format = "sqlite"
$env.config.use_kitty_protocol = true
$env.config.completions.algorithm = "substring"
$env.config.history.isolation = true
