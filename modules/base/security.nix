{
  security = {
    sudo.enable = false; # replaced by run0
    polkit = {
      enable = true;
      debug = true;
    };
  };

  environment.etc."polkit-1/polkitd.conf".text = ''
    [Polkitd]
    ExpirationSeconds=60
  '';
}
