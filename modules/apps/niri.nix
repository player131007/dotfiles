{
  flake.modules.nixos.pc = {
    programs.niri.enable = true;
    services.gnome.gnome-keyring.enable = false;
  };
  # TODO: fill up config
}
