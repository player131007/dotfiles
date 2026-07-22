# why this instead of wrappers?
# because qutebrowser puts some state in config for whatever reason

{ pkgs, username, ... }:
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

  users.users.${username}.packages = [ oldPkgs.qutebrowser ];
  my.tmpfiles =
    let
      copy =
        src: _dst:
        let
          dst = "%h/.config/qutebrowser/${_dst}";
        in
        [
          "r ${dst} - - - - -"
          "C ${dst} 0600 - - - ${src}"
        ];
    in
    builtins.concatLists [
      (copy ./config.py "config.py")
      (copy ./colors.py "colors.py")
      (copy ./yt-ads.js "greasemonkey/yt-ads.js")
      (copy ./yt-volume.js "greasemonkey/yt-volume.js")
    ];
}
