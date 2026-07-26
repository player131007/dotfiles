# why this instead of wrappers?
# because qutebrowser puts some state in config for whatever reason

{ pkgs, ... }:
{
  fonts.packages = [
    pkgs.inter
  ];

  my.user.packages = [ pkgs.qutebrowser ];
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
