{
  lib,
  pkgs,
  username,
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
    description = "Syncthing";
    documentation = [
      "man:syncthing(1)"
      "https://docs.syncthing.net/users/syncthing.html"
    ];
    wantedBy = [ "default.target" ];

    startLimitBurst = 4;
    startLimitIntervalSec = 60;
    environment = {
      STNOBROWSER = "true";
      STNORESTART = "true";
      STNOUPGRADE = "true";
      STLOGFORMATTIMESTAMP = "";
      STLOGFORMATLEVELSTRING = "false";
      STLOGFORMATLEVELSYSLOG = "true";
      STGUIADDRESS = "https://127.0.0.1:8384";
    };

    unitConfig.ConditionUser = username;

    serviceConfig = {
      ExecStart = "${lib.getExe pkgs.syncthing} serve";
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
}
