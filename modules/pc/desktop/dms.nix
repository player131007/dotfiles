{ lib, pkgs, ... }:
{
  xdg.icons.enable = true;
  environment.systemPackages = [
    pkgs.bibata-cursors
    pkgs.papirus-icon-theme
  ];

  programs.dms-shell = {
    enable = true;
    enableAudioWavelength = false;
    enableCalendarEvents = false;
    enableClipboardPaste = false;
    enableVPN = false;
  };

  services.accounts-daemon.enable = true;
  persist.at.oncedir.directories = [ "/var/lib/AccountsService" ];

  my.hjem =
    { config, ... }:
    {
      xdg.config.files = {
        "niri/config.kdl" = {
          enable = lib.mkDefault false;
          text = lib.mkAfter /* kdl */ ''
            include "dms/colors.kdl"
            include "dms/cursor.kdl"
            include "dms/wpblur.kdl"
          '';
        };

        "foot/foot.ini" = {
          enable = lib.mkDefault false;
          value.main.include = [ "${config.xdg.config.directory}/foot/dank-colors.ini" ];
        };
      };
    };
}
