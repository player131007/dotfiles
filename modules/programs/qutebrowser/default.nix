{ pkgs, ... }:
{
  fonts.packages = [
    pkgs.inter
  ];

  my.hjem = {
    packages = [ pkgs.qutebrowser ];
    xdg.config.files = {
      "qutebrowser/config.py" = {
        enable = true;
        type = "copy";
        permissions = "600";
        source = ./config.py;
      };
      "qutebrowser/colors.py" = {
        enable = true;
        type = "copy";
        permissions = "600";
        source = ./colors.py;
      };
      "qutebrowser/greasemonkey/yt-ads.js" = {
        enable = true;
        type = "copy";
        permissions = "600";
        source = ./yt-ads.js;
      };
      "qutebrowser/greasemonkey/yt-volume.js" = {
        enable = true;
        type = "copy";
        permissions = "600";
        source = ./yt-volume.js;
      };
    };
  };
}
