{
  boot.initrd.systemd.enable = true;

  system.etc.overlay = {
    enable = true;
    mutable = true;
  };

  time.timeZone = "Asia/Bangkok";
}
