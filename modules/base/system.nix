{
  boot.initrd.systemd.enable = true;

  time.timeZone = "Asia/Bangkok";

  nixpkgs = {
    config.allowUnfree = true;
    flake = {
      setNixPath = false;
      setFlakeRegistry = false;
    };
  };
}
