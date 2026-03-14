{ pkgs, ... }:
{
  xdg.icons.enable = true;
  environment.systemPackages = [ pkgs.bibata-cursors ];

  programs.dms-shell = {
    enable = true;
    enableAudioWavelength = false;
    enableCalendarEvents = false;
    enableClipboardPaste = false;
    enableVPN = false;
  };

  services.accounts-daemon.enable = true;
  persist.at.oncedir.directories = [ "/var/lib/AccountsService" ];
}
