# why this instead of wrappers?
# i often temporarily edit the niri config, and it also live reloads too

{
  config,
  lib,
  pkgs,
  tmpfilesArg,
  ...
}:
{
  options.stuff.niri-config = lib.mkOption {
    type = lib.types.lines;
  };

  config = {
    my.tmpfiles =
      let
        niri-config = pkgs.writeText "config.kdl" config.stuff.niri-config;
      in
      [
        "r %h/.config/niri/config.kdl - - - - -"
        "C %h/.config/niri/config.kdl - - - - ${niri-config}"
        "z %h/.config/niri/config.kdl 0600 - - - -"
      ];

    stuff.niri-config = builtins.readFile ./config.kdl;
    programs.niri = {
      enable = true;
      useNautilus = false;
    };

    services.gnome.gnome-keyring.enable = false;
    environment.systemPackages = [
      pkgs.xwayland-satellite
      pkgs.wl-clipboard
    ];
  };
}
