{ lib, pkgs, ... }:
{
  my.hjem = (
    { config, ... }:
    let
      inherit (lib.types) listOf package;

      cfg = config.stuff.obs;

      finalPackage = lib.mapNullable (
        obs: pkgs.wrapOBS.override { obs-studio = obs; } { plugins = cfg.plugins; }
      ) cfg.package;
    in
    {
      options.stuff.obs = {
        package = lib.mkPackageOption pkgs "obs-studio" { nullable = true; };
        plugins = lib.mkOption {
          type = listOf package;
          default = [ ];
        };
      };

      config = {
        stuff.obs.plugins = [ pkgs.obs-studio-plugins.obs-vaapi ];
        packages = lib.optionals (finalPackage != null) [ finalPackage ];
      };
    }
  );
}
