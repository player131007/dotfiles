{
  security = {
    sudo.enable = false; # replaced by run0
    polkit = {
      enable = true;
      extraArgs = [ "--log-level=info" ];
    };
  };

  environment.etc."polkit-1/polkitd.conf".text = ''
    [Polkitd]
    ExpirationSeconds=120
  '';
}
