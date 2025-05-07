{ pkgs, ... }:
{
  imports = [
    ./apps
  ];

  xdg.enable = true;

  home.username = "player131007";
  home.homeDirectory = "/home/player131007";

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
    gtk.enable = true;
  };

  home.stateVersion = "23.05";
}
