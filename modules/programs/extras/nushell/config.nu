let path_env_conversion = {
  from_string: {|s| $s | split row ':'}
  to_string: {|v| $v | str join ':'}
}

let path_like_vars = [XDG_DATA_DIRS XDG_CONFIG_DIRS XCURSOR_PATH TERMINFO_DIRS QT_PLUGIN_PATH QML2_IMPORT_PATH INFOPATH GTK_PATH]
$env.ENV_CONVERSIONS = $env.ENV_CONVERSIONS | merge ($path_like_vars | each {|e| [ $e $path_env_conversion ] } | into record)

$env.config.show_banner = false
$env.config.history.file_format = "sqlite"
$env.config.use_kitty_protocol = true
$env.config.completions.algorithm = "substring"
