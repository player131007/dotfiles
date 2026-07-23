{ pkgs, ... }:
{
  xdg.icons.enable = true;
  environment.systemPackages = [
    pkgs.bibata-cursors
    pkgs.papirus-icon-theme
  ];

  programs.dms-shell = {
    enable = true;
    systemd.enable = false;
    enableAudioWavelength = false;
    enableCalendarEvents = false;
    enableClipboardPaste = false;
    enableDynamicTheming = false;
    enableVPN = false;
  };

  services.accounts-daemon.enable = true;
  persist.at.oncedir.directories = [ "/var/lib/AccountsService" ];

  # gotta do this here, systemd-tmpfiles doesn't support copy and write at the same time
  my.tmpfiles =
    let
      niri-config = builtins.toFile "niri-config" (
        builtins.readFile ./config.kdl
        + /* kdl */ ''
          spawn-at-startup "dms" "run"
          include optional=true "dms/colors.kdl"
          include optional=true "dms/cursor.kdl"
          include optional=true "dms/wpblur.kdl"
        ''
      );
    in
    [
      "r %h/.config/niri/config.kdl - - - - -"
      "C %h/.config/niri/config.kdl 0600 - - - ${niri-config}"
    ];
}
