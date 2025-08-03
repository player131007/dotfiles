{
  flake.modules.maid.pc =
    { pkgs, ... }:
    {
      packages = [ pkgs.adw-gtk3 ];
      gsettings.extraSchemaPackages = [ pkgs.gsettings-desktop-schemas ];
      gsettings.settings = {
        org.gnome.desktop.interface.gtk-theme = "adw-gtk3";
        org.gnome.desktop.interface.color-scheme = "prefer-dark";
      };

      programs.wallust.settings.templates = {
        gtk3 = {
          template = ./gtk3.css;
          target = "~/.config/gtk-3.0/gtk.css";
        };
        gtk4 = {
          template = ./gtk4.css;
          target = "~/.config/gtk-4.0/gtk.css";
        };
      };
    };
}
