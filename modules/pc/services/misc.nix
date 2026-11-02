{
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
    };
    flatpak.enable = true;
    dbus.implementation = "broker";
  };
}
