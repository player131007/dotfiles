{ pkgs, ... }:
{
  fonts.packages = [
    pkgs.inter
    pkgs.iosevka
  ];

  my.hjem = {
    packages = [ pkgs.qutebrowser ];
    xdg.config.files = {
      "qutebrowser/config.py" = {
        enable = true;
        type = "copy";
        permissions = "600";
        source = toString ./config.py;
      };
      "qutebrowser/greasemonkey/yt-ads.js" = {
        enable = true;
        type = "copy";
        permissions = "600";
        source = toString ./yt-ads.js;
      };
    };
  };
}
