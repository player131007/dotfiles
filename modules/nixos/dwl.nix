{
  pkgs,
  config,
  lib,
  modulesPath,
  ...
}:
let
  cfg = config.stuffs.dwl;

  startupScript =
    let
      setSessionVars = lib.pipe cfg.sessionVariables [
        (lib.filterAttrs (k: v: v != null))
        (lib.mapAttrsToList (k: v: "${k}=${v}"))
      ];

      inheritedSessionVars = lib.pipe cfg.sessionVariables [
        (lib.filterAttrs (k: v: v == null))
        builtins.attrNames
      ];

      allSessionVars = builtins.attrNames cfg.sessionVariables;
    in
    pkgs.writeShellScript "dwl-startup" ''
      exec <&-

      cleanup() {
          systemctl --user stop dummy-graphical-session.service

          ${lib.optionalString (
            allSessionVars != [ ]
          ) "systemctl --user unset-environment ${lib.escapeShellArgs allSessionVars}"}
      }
      trap cleanup EXIT

      ${lib.optionalString (
        setSessionVars != [ ]
      ) "systemctl --user set-environment ${lib.escapeShellArgs setSessionVars}"}
      ${lib.optionalString (
        inheritedSessionVars != [ ]
      ) "systemctl --user import-environment ${lib.escapeShellArgs inheritedSessionVars}"}
      systemctl --user start dummy-graphical-session.service

      ${cfg.startupCommand}
      sleep inf
    '';

  dwl-script =
    let
      envVars = lib.pipe cfg.envVariables [
        (lib.mapAttrsToList (k: v: "${k}=${v}"))
        lib.escapeShellArgs
      ];
    in
    pkgs.writeShellScript "dwl" ''
      export ${envVars}
      exec ${lib.getExe cfg.package} -s ${startupScript} "$@"
    '';

  dwl-wrapped =
    pkgs.runCommandLocal "dwl-wrapped"
      {
        buildInputs = [
          pkgs.dbus
          cfg.package
        ];
        passthru.providedSessions = [ "dwl" ];
      }
      ''
        mkdir -p $out/bin
        cp -r ${cfg.package}/share $out
        cp ${dwl-script} $out/bin/dwl
      '';
in
{
  options.stuffs.dwl =
    let
      inherit (lib.types) attrsOf str nullOr;
    in
    {
      enable = lib.mkEnableOption "dwl";
      package = lib.mkPackageOption pkgs "dwl" { };

      sessionVariables = lib.mkOption {
        type = attrsOf (nullOr str);
        description = ''
          Environment variables to pass to the dbus session and systemd services.
          If the value is `null`, the variable will be inherited.
        '';
      };

      envVariables = lib.mkOption {
        type = attrsOf str;
        description = "Environment variables to pass to dwl.";
      };

      startupCommand = lib.mkOption {
        type = str;
        default = "";
        description = ''
          Command to run after dwl starts.
          Note that this will be ran as a child process and thus can't change the environment of dwl.
        '';
      };
    };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        stuffs.dwl.sessionVariables = lib.mapAttrs (_: lib.mkDefault) {
          XDG_CURRENT_DESKTOP = null;
          WAYLAND_DISPLAY = null;
        };

        stuffs.dwl.envVariables = lib.mapAttrs (_: lib.mkDefault) {
          XDG_CURRENT_DESKTOP = "dwl:wlroots";
        };

        systemd.user.services.dummy-graphical-session = {
          description = "Dummy service that pulls in graphical-session.target";
          bindsTo = [ "graphical-session.target" ];
          serviceConfig = {
            Type = "exec";
            ExecStart = "${lib.getExe' pkgs.coreutils "sleep"} inf";
          };
        };

        environment.systemPackages = [ dwl-wrapped ];
        services.displayManager.sessionPackages = [ dwl-wrapped ];

        xdg.portal.config.wlroots = {
          default = [
            "wlr"
            "gtk"
          ];
        };
      }
      (import "${modulesPath}/programs/wayland/wayland-session.nix" { inherit lib pkgs; })
    ]
  );
}
