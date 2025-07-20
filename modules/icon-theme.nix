{
  flake.modules.nixos.pc = {
    xdg.icons.enable = true;
  };

  flake.modules.maid.pc =
    { pkgs, ... }:
    {
      packages = [ pkgs.colloid-icon-theme ];
      gsettings.settings = {
        org.gnome.desktop.interface.icon-theme = "Colloid-Dark";
      };
    };
}
