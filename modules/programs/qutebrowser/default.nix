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
        clobber = false;
        source = toString ./config.py;
      };
      "qutebrowser/greasemonkey/yt-ads.js" = {
        enable = true;
        type = "copy";
        permissions = "600";
        clobber = false;
        source = toString ./yt-ads.js;
      };
    };
  };
}
