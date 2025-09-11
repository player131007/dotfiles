{
  flake.modules.maid.programs =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.programs.wallust;
      tomlFormat = pkgs.formats.toml { };
      wallust-script = pkgs.writeShellScriptBin "e" ''
        set -uo pipefail

        ${lib.getExe cfg.package} run "$@" || exit 1

        ${cfg.extraCommands}
      '';
    in
    {
      options.programs.wallust = {
        enable = lib.mkEnableOption "wallust";
        package = lib.mkPackageOption pkgs "wallust" { };
        settings = lib.mkOption {
          inherit (tomlFormat) type;
          default = { };
        };
        extraCommands = lib.mkOption {
          type = lib.types.lines;
          description = "extra commands to run after running wallust";
          default = "";
        };
      };

      config = lib.mkIf cfg.enable {
        file.xdg_config."wallust/wallust.toml".source = tomlFormat.generate "wallust.toml" cfg.settings;
        packages = [
          cfg.package
          wallust-script
        ];
      };
    };
}
