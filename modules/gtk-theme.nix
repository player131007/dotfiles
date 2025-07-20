{
  flake.modules.maid.pc =
    { pkgs, ... }:
    {
      packages = [ pkgs.adw-gtk3 ];
      gsettings.extraSchemaPackages = [ pkgs.gsettings-desktop-schemas ];
      gsettings.settings = {
        org.gnome.desktop.interface.gtk-theme = "adw-gtk3";
      };
    };
}
