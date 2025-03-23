{pkgs, ...}: {
  imports = [
    ./apps
  ];

  xdg.enable = true;
  xdg.configFile."startup".source = pkgs.writeShellScript "startup" ''
    exec <&-

    nohup swaybg -i ${./wallpaper.png} &
    nohup keepassxc &
    nohup yambar -d none &

    wait -f
  '';

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
