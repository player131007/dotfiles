{
  flake.modules.maid.programs =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      cfg = config.programs.obs-studio;
      finalPackage = pkgs.wrapOBS.override { obs-studio = cfg.package; } { inherit (cfg) plugins; };
    in
    {
      options.programs.obs-studio = {
        enable = lib.mkEnableOption "obs studio";
        package = lib.mkPackageOption pkgs "obs-studio" { };

        plugins = lib.mkOption {
          type = lib.types.listOf (lib.types.package);
          default = [ ];
        };
      };

      config = lib.mkIf cfg.enable {
        packages = [ finalPackage ];
      };
    };
}
