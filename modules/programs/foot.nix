{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.generators) toINI mkKeyValueDefault mkValueStringDefault;
in
{
  fonts.packages = [
    pkgs.nerd-fonts.iosevka-term
  ];

  my.hjem = {
    packages = [ pkgs.foot ];
    xdg.config.files."foot/foot.ini" = {
      enable = true;
      type = "copy";
      permissions = "600";
      clobber = false;

      generator = toINI {
        listsAsDuplicateKeys = true;
        mkKeyValue = mkKeyValueDefault {
          mkValueString = v: mkValueStringDefault { } (if v == "" then "''" else v);
        } "=";
      };
      value = {
        main = {
          pad = "5x5 center";
          font = lib.concatStringsSep "," [
            "IosevkaTerm Nerd Font:size=9"
          ];
          dpi-aware = "yes";
        };
        cursor.blink = "yes";
        colors.alpha = 0.9;
      };
    };
  };
}
