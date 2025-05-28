{ pkgs, ... }:
{
  imports = [
    ./apps
  ];

  xdg.enable = true;

  home.packages = [ pkgs.nerd-fonts.iosevka-term ];

  fonts.fontconfig.defaultFonts.monospace = [ "IosevkaTerm NF" ];

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
    gtk.enable = true;
  };

  home.stateVersion = "23.05";
}
