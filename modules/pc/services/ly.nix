{ pkgs, ... }:
{
  services.displayManager.ly = {
    enable = true;
    settings = {
      brightness_down_cmd = null;
      brightness_down_key = null;
      brightness_up_cmd = null;
      brightness_up_key = null;
      show_password_key = null;
      xinitrc = null;
      clear_password = true;
      ly_log = "/run/ly.log";
      custom_sessions = "${pkgs.emptyDirectory}";
      setup_cmd =
        pkgs.writeScript "ly-setup" ''
          #!/bin/sh
          [ -f /etc/profile ] && . /etc/profile
          [ -f ~/.profile ] && . ~/.profile
          unset -v SHLVL
          exec "$@"
        ''
        |> toString;
      default_input = "password";
    };
  };
}
