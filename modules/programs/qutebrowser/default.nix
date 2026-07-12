{ pkgs, ... }:
let
  # FIXME: remove
  oldPkgs = import (fetchTarball {
    url = "https://releases.nixos.org/nixos/unstable/nixos-26.11pre1017464.567a49d1913c/nixexprs.tar.xz";
    sha256 = "sha256-rcUHdUtJEvMdNEl2Wq+YpHraHKfcer3KsBscpZEF2Yg=";
  }) { };
in
{
  fonts.packages = [
    pkgs.inter
  ];

  my.hjem = {
    packages = [ oldPkgs.qutebrowser ];
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
