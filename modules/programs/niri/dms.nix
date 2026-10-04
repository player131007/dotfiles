{ lib, pkgs, ... }:
{
  xdg.icons.enable = true;
  environment.systemPackages = [
    pkgs.bibata-cursors
    pkgs.papirus-icon-theme
  ];

  programs.dms-shell = {
    enable = true;
    systemd.enable = false;
    excludePackages = [
      pkgs.matugen
      pkgs.cava
    ];
  };

  services.accounts-daemon.enable = true;
  persist.at.oncedir.directories = [ "/var/lib/AccountsService" ];

  my.hjem = {
    xdg.config.files."niri/config.kdl".text =
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
      in
      lib.mkAfter ''
        spawn-at-startup "dms" "run"
        include optional=true "dms/colors.kdl"
        include optional=true "dms/cursor.kdl"
        include optional=true "dms/wpblur.kdl"
        include "${dms-keybinds}"
      '';
  };
}
