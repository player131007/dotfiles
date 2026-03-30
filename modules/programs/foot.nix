{
  lib,
  pkgs,
  sources,
  ...
}:
let
  inherit (lib.generators) toINI mkKeyValueDefault mkValueStringDefault;

  rose-pine = sources.rose-pine-foot { inherit pkgs; };
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
          include = [ "${rose-pine}/rose-pine" ];
          dpi-aware = "yes";
        };
        cursor.blink = "yes";
        colors-dark.alpha = 0.9;
        colors-light.alpha = 0.9;
      };
    };
  };
}
