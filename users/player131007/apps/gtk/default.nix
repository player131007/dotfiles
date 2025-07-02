{
  pkgs,
  ...
}:
let
  gtkConfig = {
  };
in
{
  gtk = {
    enable = true;
    font = {
      package = pkgs.inter;
      name = "Inter";
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3";
    };

    gtk3 = gtkConfig;
    gtk4 = gtkConfig;
  };
}
