{
  lib,
  pkgs,
  config,
  my,
  ...
}:
let
  extra-config = "${config.hjem.users.${my.name}.xdg.config.directory}/foot/extra.ini";
in
{
  # without this, ctrl/alt + backspace on the combo fish + foot doesn't work
  # see https://codeberg.org/dnkl/foot/issues/2048
  services.xserver.xkb.options = "";

  fonts.packages = [
    pkgs.nerd-fonts.symbols-only
    pkgs.iosevka
  ];

  my.tmpfiles.rules = [ "f ${extra-config} - - -" ];

  my.hjem = {
    packages = [ pkgs.foot ];
    xdg.config.files."foot/foot.ini" = {
      generator =
        let
          inherit (lib.generators) toINI mkKeyValueDefault mkValueStringDefault;
        in
        (
          v:
          lib.pipe v.config [
            (map (toINI {
              mkKeyValue = mkKeyValueDefault {
                mkValueString = v: if v == "" then "\"\"" else (mkValueStringDefault { } v);
              } "=";
            }))
            lib.strings.concatLines
          ]
        );
      value.config = [
        {
          main = {
            shell = "fish";
            pad = "5x5 center";
            font = lib.concatStringsSep "," [
              "Iosevka:style=Regular:size=9"
              "Symbols Nerd Font Mono:size=9"
            ];
            dpi-aware = "yes";
          };
          cursor.blink = "yes";
          colors.alpha = 0.9;
        }
        {
          main.include = extra-config;
        }
      ];
    };
  };
}
