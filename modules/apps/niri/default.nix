{
  flake.modules.nixos.pc =
    { pkgs, ... }:
    {
      programs.niri.enable = true;
      services.gnome.gnome-keyring.enable = false;
      environment.systemPackages = [ pkgs.nautilus ]; # for xdg-desktop-portal-gnome
    };

  flake.modules.maid.pc = {
    file.xdg_config."niri/config.kdl".source = ./config.kdl;
  };
}
