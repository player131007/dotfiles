{
  security = {
    sudo.enable = false;
    run0.enable = true;
    polkit = {
      extraArgs = [ "--log-level=info" ];
      settings.Polkitd.ExpirationSeconds = 120;
    };
  };
}
