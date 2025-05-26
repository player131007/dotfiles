{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.programs.ringboard;
in
{
  options.programs.ringboard = {
    enable = lib.mkEnableOption "Ringboard, a clipboard manager for Linux";
    package = lib.mkPackageOption pkgs "ringboard-server" { };
    x11 = {
      enable = lib.mkEnableOption "the X11 clipboard listener for Ringboard";
      package = lib.mkPackageOption pkgs "ringboard-x11" { };
    };
    wayland = {
      enable = lib.mkEnableOption "the Wayland clipboard listener for Ringboard";
      package = lib.mkPackageOption pkgs "ringboard-wayland" { };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services = {
      ringboard-server = {
        Unit = {
          Description = "Ringboard server";
          Documentation = "https://github.com/SUPERCILEX/clipboard-history";
          After = "multi-user.target";
        };
        Service = {
          Type = "notify";
          Environment = [ "RUST_LOG=debug" ];
          ExecStart = lib.getExe cfg.package;
          Restart = "always"; # server can gracefully die when running `ringboard wipe`
          Slice = "ringboard.slice";
        };
        Install = {
          WantedBy = [ "multi-user.target" ];
        };
      };

      ringboard-x11 = lib.mkIf cfg.x11.enable {
        Unit = {
          Description = "X11 Ringboard clipboard listener";
          Documentation = "https://github.com/SUPERCILEX/clipboard-history";
          Requires = "ringboard-server.service";
          BindsTo = "graphical-session.target";
          After = [
            "ringboard-server.service"
            "graphical-session.target"
          ];
        };
        Service = {
          Type = "exec";
          Environment = [ "RUST_LOG=debug" ];
          ExecStart = lib.getExe cfg.x11.package;
          Restart = "on-failure";
          Slice = "ringboard.slice";
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };

      ringboard-wayland = lib.mkIf cfg.wayland.enable {
        Unit = {
          Description = "Wayland Ringboard clipboard listener";
          Documentation = "https://github.com/SUPERCILEX/clipboard-history";
          Requires = "ringboard-server.service";
          BindsTo = "graphical-session.target";
          After = [
            "ringboard-server.service"
            "graphical-session.target"
          ];
        };
        Service = {
          Type = "exec";
          Environment = [ "RUST_LOG=debug" ];
          ExecStart = lib.getExe cfg.wayland.package;
          Restart = "on-failure";
          RestartSec = "10s";
          RestartSteps = 5;
          RestartMaxDelaySec = "1min";
          Slice = "ringboard.slice";
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
    };
  };
}
