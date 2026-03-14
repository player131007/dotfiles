{
  lib,
  pkgs,
  ...
}:
{
  networking.firewall = {
    allowedTCPPorts = [ 22000 ];
    allowedUDPPorts = [
      22000
      21027
    ];
  };

  systemd.user.services.syncthing = {
    description = "Syncthing - Open Source Continuous File Synchronization";
    documentation = [
      "man:syncthing(1)"
      "https://docs.syncthing.net/users/syncthing.html"
    ];
    wantedBy = [ "default.target" ];
    path = lib.mkForce [ ];

    startLimitBurst = 4;
    startLimitIntervalSec = 60;

    serviceConfig = {
      ExecStart = lib.escapeShellArgs [
        (lib.getExe pkgs.syncthing)
        "serve"
        "--gui-address=https://127.0.0.1:8384"

        "--no-restart"
        "--no-browser"
        "--no-upgrade"

        "--no-log-format-level-string"
        "--log-format-timestamp="
        "--log-format-level-syslog"
      ];
      Restart = "on-failure";
      RestartSec = 1;
      RestartForceExitStatus = "3 4";
      SuccessExitStatus = "3 4";

      ProtectSystem = "full";

      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      ProtectControlGroups = true;
      ProtectHostname = true;
      ProtectClock = true;

      NoNewPrivileges = true;

      RestrictSUIDSGID = true;

      MemoryDenyWriteExecute = true;

      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictAddressFamilies = [
        "AF_INET"
        "AF_INET6"
        "AF_NETLINK"
        "AF_UNIX"
      ];

      CapabilityBoundingSet = [ ];
      AmbientCapabilities = [ ];

      LockPersonality = true;
      SystemCallArchitectures = "native";
      SystemCallFilter = "@system-service";
      SystemCallErrorNumber = "EPERM";

      RemoveIPC = true;
      PrivateIPC = true;
      PrivateTmp = "disconnected";
      PrivateDevices = true;
      DevicePolicy = "closed";
      PrivatePIDs = true;
      ProtectProc = "invisible";
      ProcSubset = "pid";
      UMask = "7027";
    };
  };
}
