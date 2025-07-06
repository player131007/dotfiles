{
  flake.modules.nixos.pc = {
    networking.firewall = {
      allowedTCPPorts = [ 22000 ];
      allowedUDPPorts = [
        21027
        22000
      ];
    };
  };

  flake.modules.maid.pc =
    { lib, pkgs, ... }:
    {
      systemd.services.syncthing = {
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        description = "Syncthing - Open Source Continuous File Synchronization";
        documentation = [ "man:syncthing(1)" ];
        startLimitBurst = 4;
        startLimitIntervalSec = 60;
        serviceConfig = {
          ExecStart = "${lib.getExe pkgs.syncthing} serve --logflags=0 --no-browser --no-restart --no-upgrade --gui-address=127.0.0.1:8384";
          Restart = "on-failure";
          RestartForceExitStatus = "3 4";
          SuccessExitStatus = "3 4";
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = "@system-service";
          PrivateDevices = true;
          PrivateMounts = true;
          PrivateTmp = true;
          PrivateUsers = true;
          ProtectControlGroups = true;
          ProtectHostname = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          CapabilityBoundingSet = [
            "~CAP_SYS_PTRACE"
            "~CAP_SYS_ADMIN"
            "~CAP_SETGID"
            "~CAP_SETUID"
            "~CAP_SETPCAP"
            "~CAP_SYS_TIME"
            "~CAP_KILL"
          ];
        };
      };
    };
}
