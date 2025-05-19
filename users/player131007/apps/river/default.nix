{
  pkgs,
  lib,
  config,
  ...
}:
{
  wayland.windowManager.river =
    let
      colors = config.colorscheme.palette;
    in
    {
      enable = true;
      package = null;
      settings = {
        allow-tearing = true;
        border-color-focused = "0x${colors.base0C}AA";
        border-color-unfocused = "0x${colors.base03}AA";
        border-color-urgent = "0x${colors.base08}";
        border-width = 3;
        declare-mode = [
          /*
            for stuff that needs to capture the keyboard
            keyboard-shortcuts-inhibit?
          */
          "passthrough"
        ];
        output-layout = "rivertile";

        rule-add = {
          "" = "ssd";
        };

        map =
          let
            movements =
              action:
              lib.mapAttrs (_: move: "${action} ${move}") {
                "J" = "previous";
                "K" = "next";
                "up" = "up";
                "down" = "down";
                "left" = "left";
                "right" = "right";
              };
          in
          {
            passthrough."Alt Insert" = "enter-mode normal";
            normal = {
              "Alt Insert" = "enter-mode passthrough";

              "Super Q" = "spawn foot";
              "Super A" = "spawn firefox";
              "Super D" = "spawn keepassxc";

              "Super W" = "toggle-float";
              "Super E" = "toggle-fullscreen";

              "Super H" = "send-layout-cmd rivertile \"main-ratio -0.1\"";
              "Super L" = "send-layout-cmd rivertile \"main-ratio +0.1\"";

              "Super C" = "close";
              "Super+Shift M" = "exit";

              "Super Return" = "zoom";

              "Super" = movements "focus-view";
              "Super+Alt" = movements "focus-output";
            };
            "-repeat normal" = {
              "None XF86MonBrightnessDown" = "spawn \"brightnessctl s 10%-\"";
              "None XF86MonBrightnessUp" = "spawn \"brightnessctl s 10%+\"";
              "None XF86AudioMicMute" = "spawn \"wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle\"";
              "None XF86AudioMute" = "spawn \"wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle\"";
              "None XF86AudioLowerVolume" = "spawn \"wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 2%-\"";
              "None XF86AudioRaiseVolume" = "spawn \"wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 2%+\"";
            };
          };
        map-pointer.normal.Super = {
          BTN_LEFT = "move-view";
          BTN_RIGHT = "resize-view";
        };

        input = {
          "\*Touchpad" = {
            accel-profile = "adaptive";
            click-method = "button-areas";
            natural-scroll = true;
            tap = true;
            tap-button-map = "left-right-middle";
            drag = true;
          };
        };
        spawn = map (s: "\"${s}\"") [
          "rivertile -main-ratio 0.5"
          "${lib.getExe pkgs.swaybg} -i ${../../wallpaper.png} -m fill"
          "keepassxc --minimized"
        ];

        set-repeat = "30 300";
      };

      extraConfig = ''
        for i in {1..9}; do
          tags=$((1 << ($i - 1)))
          riverctl map normal Super $i set-focused-tags $tags
          riverctl map normal Super+Shift $i set-view-tags $tags
          riverctl map normal Super+Control $i toggle-focused-tags $tags
          riverctl map normal Super+Shift+Control $i toggle-view-tags $tags
        done

        all_tags=$(((1 << 32) - 1))
        riverctl map normal Super 0 set-focused-tags $all_tags
        riverctl map normal Super+Shift 0 set-view-tags $all_tags

        wlr-randr --output eDP-1 --scale 1.125 --adaptive-sync enabled
      '';
    };

  home.packages = with pkgs; [
    grim
    slurp
    foot
    wl-clipboard
    wl-screenrec
    wlr-randr
  ];
}
