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
      dms-keybinds = builtins.toFile "dms-keybinds.kdl" ''
        binds {
            Super+Alt+L repeat=false hotkey-overlay-title="Lock the Screen" { spawn "dms" "ipc" "call" "lock" "lock"; }

            Mod+S repeat=false { spawn "dms" "ipc" "spotlight" "toggle"; }

            XF86AudioRaiseVolume allow-when-locked=true { spawn "dms" "ipc" "call" "audio" "increment" "5"; }
            XF86AudioLowerVolume allow-when-locked=true { spawn "dms" "ipc" "call" "audio" "decrement" "5"; }
            XF86AudioMute        allow-when-locked=true { spawn "dms" "ipc" "call" "audio" "mute"; }
            XF86AudioMicMute     allow-when-locked=true { spawn "dms" "ipc" "call" "audio" "micmute"; }

            XF86MonBrightnessUp  allow-when-locked=true { spawn "dms" "ipc" "call" "brightness" "increment" "10" ""; }
            XF86MonBrightnessDown allow-when-locked=true { spawn "dms" "ipc" "call" "brightness" "decrement" "10" ""; }
        }
      '';
      niri-config = builtins.toFile "niri-config" (
        builtins.readFile ./config.kdl
        + /* kdl */ ''
          spawn-at-startup "dms" "run"
          include optional=true "dms/colors.kdl"
          include optional=true "dms/cursor.kdl"
          include optional=true "dms/wpblur.kdl"
          include "${dms-keybinds}"
        ''
      );
    in
    [
      "r %h/.config/niri/config.kdl - - - - -"
      "C %h/.config/niri/config.kdl 0600 - - - ${niri-config}"
    ];
}
