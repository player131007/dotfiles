{
  security = {
    sudo.enable = false; # replaced by run0
    polkit = {
      enable = true;
      debug = true;
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (action.id == "org.freedesktop.systemd1.manage-units") {
            return polkit.Result.AUTH_ADMIN_KEEP;
          }
        });
      '';
    };
  };

  environment.etc."polkit-1/polkitd.conf".text = ''
    [Polkitd]
    ExpirationSeconds=60
  '';
}
