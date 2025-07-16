{
  flake.modules.nixos.pc = {
    programs.niri.enable = true;
    services.gnome.gnome-keyring.enable = false;
  };

  flake.modules.maid.pc =
    { pkgs, ... }:
    {
      packages = [
        pkgs.nautilus
        pkgs.bibata-cursors
      ];
      file.xdg_config."niri/config.kdl".source = ./config.kdl;
    };
}
