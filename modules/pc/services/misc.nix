{
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
    };

    dbus.implementation = "broker";
  };
}
