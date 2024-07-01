{ config, pkgs, ... }: {
    wayland.windowManager.hyprland = {
        enable = true;
        settings = {
            monitor = ", preferred, auto, 1.25";
            exec-once = [
                "${pkgs.swaybg}/bin/swaybg -i ${../../wallpaper.png}"
            ];

            env = [
                "QT_QPA_PLATFORM,wayland"
                "GDK_BACKEND,wayland"
            ];

            general = with config.scheme; {
                layout = "dwindle";

                gaps_in = 5;
                gaps_out = 15;

                border_size = 2;

                "col.active_border" = "0xf0${base0B}";
                "col.inactive_border" = "0xee${base01}";
                "col.nogroup_border_active" = "0xf0${base08}";
                "col.nogroup_border" = "0xee${base01}";
            };

            dwindle = {
                pseudotile = true;
                preserve_split = true;
            };

            decoration = {
                rounding = 7;
                drop_shadow = false;

                inactive_opacity = 0.8;
                dim_inactive = true;
                dim_strength = 0.15;

                blur = {
                    enabled = true;
                    size = 5;
                };
            };

            input = {
                follow_mouse = 2;
                repeat_delay = 400;

                touchpad.natural_scroll = true;
            };

            animations = {
                enabled = true;

                bezier = [
                    "md3_accel, 0.3, 0, 0.8, 0.15"
                    "overshot, 0.05, 0.9, 0.1, 1.1"
                    "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
                ];

                animation = [
                    "windowsIn, 1, 1.5, hyprnostretch, popin 60%"
                    "windowsOut, 1, 2, md3_accel, slide"
                    "workspaces, 1, 4, overshot, slidefade 30%"
                ];
            };

            bind = [
                "SUPER, M, exit,"
                "SUPER, C, killactive"
                "SUPER, V, togglefloating,"
                "SUPER, P, pseudo,"
                "SUPER, J, togglesplit,"

                "SUPER, Q, exec, foot"
                "SUPER, F, exec, firefox"

                "SUPER, up, movefocus, u"
                "SUPER, down, movefocus, d"
                "SUPER, left, movefocus, l"
                "SUPER, right, movefocus, r"

                "SUPER, s, togglespecialworkspace"
                "SUPER, 1, workspace, 1"
                "SUPER, 2, workspace, 2"
                "SUPER, 3, workspace, 3"
                "SUPER, 4, workspace, 4"
                "SUPER, 5, workspace, 5"
                "SUPER, 6, workspace, 6"
                "SUPER, 7, workspace, 7"
                "SUPER, 8, workspace, 8"
                "SUPER, 9, workspace, 9"
                "SUPER, 0, workspace, 10"

                "SUPER SHIFT, s, movetoworkspace, special"
                "SUPER SHIFT, 1, movetoworkspace, 1"
                "SUPER SHIFT, 2, movetoworkspace, 2"
                "SUPER SHIFT, 3, movetoworkspace, 3"
                "SUPER SHIFT, 4, movetoworkspace, 4"
                "SUPER SHIFT, 5, movetoworkspace, 5"
                "SUPER SHIFT, 6, movetoworkspace, 6"
                "SUPER SHIFT, 7, movetoworkspace, 7"
                "SUPER SHIFT, 8, movetoworkspace, 8"
                "SUPER SHIFT, 9, movetoworkspace, 9"
                "SUPER SHIFT, 0, movetoworkspace, 10"

                ", XF86MonBrightnessDown, exec, brightnessctl set -n 15%-"
                ", XF86MonBrightnessUp, exec, brightnessctl set -n 15%+"
            ];

            bindm = [
                "SUPER, mouse:272, movewindow"
                "SUPER, mouse:273, resizewindow"
            ];

            bindl = [
                ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
                ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
            ];

            bindle = [
                ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 2%-"
                ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 2%+"
            ];
        };
    };
}
