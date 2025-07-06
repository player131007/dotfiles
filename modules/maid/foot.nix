{
  flake.modules.maid.programs =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.programs.foot;
      iniFormat = pkgs.formats.ini { listsAsDuplicateKeys = true; };
    in
    {
      options.programs.foot = {
        enable = lib.mkEnableOption "foot terminal";
        package = lib.mkPackageOption pkgs "foot" { };
        settings = lib.mkOption {
          inherit (iniFormat) type;
          default = { };
        };
      };

      config = lib.mkIf cfg.enable {
        packages = [ cfg.package ];
        file.xdg_config."foot/foot.ini" = lib.mkIf (cfg.settings != { }) {
          source = iniFormat.generate "foot.ini" cfg.settings;
        };
      };
    };
}
