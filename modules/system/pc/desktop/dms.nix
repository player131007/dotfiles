{ lib, config, ... }:
{
  programs.dms-shell = {
    enable = true;
    enableAudioWavelength = false;
    enableCalendarEvents = false;
    enableVPN = false;
  };

  persist.at.oncedir.directories = [
    (lib.mkIf config.services.power-profiles-daemon.enable "/var/lib/power-profiles-daemon")
    (lib.mkIf config.services.accounts-daemon.enable "/var/lib/AccountsService")
  ];
}
