{
  security = {
    sudo.enable = false;
    run0.enable = true;
    polkit.extraArgs = [ "--log-level=info" ];
  };

  environment.etc."polkit-1/polkitd.conf".text = ''
    [Polkitd]
    ExpirationSeconds=120
  '';
}
