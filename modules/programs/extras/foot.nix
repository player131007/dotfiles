{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.generators) toINI mkKeyValueDefault mkValueStringDefault;
in
{
  # without this, ctrl/alt + backspace on the combo fish + foot doesn't work
  # see https://codeberg.org/dnkl/foot/issues/2048
  services.xserver.xkb.options = "";

  fonts.packages = [
    pkgs.nerd-fonts.iosevka-term
  ];

  my.hjem = {
    packages = [ pkgs.foot ];
    xdg.config.files."foot/foot.ini" = {
      enable = true;
      type = "copy";
      permissions = "600";
      clobber = true;

      generator = toINI {
        listsAsDuplicateKeys = true;
        mkKeyValue = mkKeyValueDefault {
          mkValueString =
            v:
            mkValueStringDefault { } (
              if v == true then
                "yes"
              else if v == false then
                "no"
              else if v == null then
                "none"
              else
                v
            );
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
