{
  flake.modules.maid.programs =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      graphical = config.maid.systemdGraphicalTarget;
      swww-daemon = config.systemd.services.swww-daemon.name;
      cfg = config.programs.swww;
    in
    {
      options.programs.swww = {
        enable = lib.mkEnableOption "swww";
        package = lib.mkPackageOption pkgs "swww" { };
      };

      config = lib.mkIf cfg.enable {
        packages = [ cfg.package ];
        systemd.services = {
          swww-daemon = {
            wantedBy = [ graphical ];
            after = [ graphical ];
            partOf = [ graphical ];
            documentation = [ "man:swww-daemon(1)" ];
            unitConfig.ConditionEnvironment = "WAYLAND_DISPLAY";
            serviceConfig.ExecStart = lib.getExe' cfg.package "swww-daemon";
          };
          swww-restore = {
            wantedBy = [ graphical ];
            partOf = [ swww-daemon ];
            requires = [ swww-daemon ];
            after = [
              graphical
              swww-daemon
            ];
            documentation = [ "man:swww-restore(1)" ];
            unitConfig.ConditionEnvironment = "WAYLAND_DISPLAY";
            serviceConfig.ExecStart = "${lib.getExe cfg.package} restore";
          };
        };
      };
    };
}
