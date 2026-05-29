{ ... }:
{
  wayland.windowManager.hyprland = {
    settings = {

      "$mainMod" = "SUPER";
      
      exec-once =[
        "systemctl --user import-environment &"
        "hash dbus-update-activation-environment 2>/dev/null &"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &"
        "nm-applet &"
        "wl-clip-persist --clipboard both"
        "swaybg -m fill -i $(find ~/Pictures/wallpapers/ -maxdepth 1 -type f) &"
        "hyprctl setcursor Bibata-Modern-Ice 24 &"
        "poweralertd &"
        "waybar &"
        "swaync &"
        "wl-paste --watch cliphist store &"
        "hyprlock"
        "wlsunset -S 06:00 -s 21:00 -d 120"
        "[workspace 1 silent] AyuGram"
        "[workspace 2 silent] zen-beta"
        #"sleep 4; hyprctl dispatch exec '[workspace 1 silent] kitty --class kitty-ws1'"
        #"sleep 4; hyprctl dispatch exec '[workspace 2 silent] kitty --class kitty-ws2'"
        #"sleep 6; hyprctl dispatch workspace 2; hyprctl dispatch focuswindow class:kitty-ws2; hyprctl dispatch splitratio exact 0.33; hyprctl dispatch workspace 1"
        "sh -c 'sleep 3 && hyprctl dispatch exec \"[workspace 1 silent] kitty --class kitty-ws1\"'"
        "sh -c 'sleep 3 && hyprctl dispatch exec \"[workspace 2 silent] kitty --class kitty-ws2\" && sleep 2 && hyprctl dispatch workspace 2 && hyprctl dispatch focuswindow kitty-ws2 && hyprctl dispatch splitratio exact 0.33 && hyprctl dispatch workspace 1'"
      ];

      input = {
        kb_layout = "us,ru";
        kb_options = "grp:alt_shift_toggle";
        numlock_by_default = true;
        follow_mouse = 1;
        float_switch_override_focus = 0;
        mouse_refocus = 0;
        sensitivity = 0;
        touchpad = {
          natural_scroll = true;
        };
      };

      general = {
        layout = "dwindle";
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgb(98971a) rgb(cc241d) 45deg";
        "col.inactive_border" = "0x00000000";
      };

      misc = {
        disable_autoreload = true;
        disable_hyprland_logo = true;
        enable_swallow = true;
        focus_on_activate = true;
        on_focus_under_fullscreen = 2;
        middle_click_paste = false;
      };

      workspace = [
        "w[tv1], gapsout:0, gapsin:0"
        "f[1], gapsout:0, gapsin:0"
      ];

      dwindle = {
        force_split = 0;
        use_active_for_splits = true;
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "master";
      };

      decoration = {
        rounding = 0;
        
        blur = {
          enabled = true;
          size = 2;
          passes = 2;
          brightness = 1;
          contrast = 1.4;
          ignore_opacity = true;
          noise = 0;
          xray = true;
        };

        shadow = {
          enabled = true;
          ignore_window = true;
          offset = "0 2";
          range = 20;
          render_power = 3;
          color = "rgba(00000055)";
        };
      };

      animations = {
        enabled = true;

        bezier =[
          "fluent_decel, 0, 0.2, 0.4, 1"
          "easeOutCirc, 0, 0.55, 0.45, 1"
          "easeOutCubic, 0.33, 1, 0.68, 1"
          "easeinoutsine, 0.37, 0, 0.63, 1"
        ];

        animation =[
          "windowsIn, 1, 4, easeOutCubic, popin 20%"
          "windowsOut, 1, 4, fluent_decel, popin 80%"
          "windowsMove, 1, 2, easeinoutsine, slide"
          "fadeIn, 1, 3, easeOutCubic"
          "fadeOut, 1, 2, easeOutCubic"
          "fadeSwitch, 0, 1, easeOutCirc"
          "fadeShadow, 1, 10, easeOutCirc"
          "fadeDim, 1, 4, fluent_decel"
          "border, 1, 2.7, easeOutCirc"
          "borderangle, 1, 30, fluent_decel, once"
          "workspaces, 1, 5, easeOutCubic, fade"
        ];
      };

      bind =[
        "$mainMod, F1, exec, show-keybinds"
        "$mainMod, Return, exec, kitty"
        "ALT, Return, exec, kitty --title float_kitty"
        "$mainMod SHIFT, Return, exec, kitty --start-as=fullscreen -o 'font_size=16'"
        "$mainMod, B, exec, zen-beta"
        "$mainMod, Q, killactive,"
        "$mainMod, F, fullscreen, 0"
        "$mainMod SHIFT, F, fullscreen, 1"
        "$mainMod, Space, exec, toggle_float"
        "$mainMod, D, exec, rofi -show drun || pkill rofi"
        "$mainMod SHIFT, D, exec, [workspace 4 silent] discord --enable-features=UseOzonePlatform --ozone-platform=wayland"
        "$mainMod SHIFT, S, exec,[workspace 5 silent] SoundWireServer"
        "$mainMod, Escape, exec, swaylock"
        "ALT, Escape, exec, hyprlock"
        "$mainMod SHIFT, Escape, exec, power-menu"
        "$mainMod, P, pseudo,"
        "$mainMod, J, togglesplit,"
        "$mainMod, O, exec, toggle_oppacity"
        "$mainMod, E, exec, nautilus"
        "$mainMod, T, exec, AyuGram"
        "$mainMod SHIFT, B, exec, toggle_waybar"
        "$mainMod, C ,exec, hyprpicker -a"
        "$mainMod, W,exec, wallpaper-picker"
        "$mainMod, N, exec, swaync-client -t -sw"
        "$mainMod SHIFT, W, exec, vm-start"

        "$mainMod, S, exec, grimblast --notify --freeze save area ~/Pictures/$(date +'%Y-%m-%d-At-%Ih%Mm%Ss').png"
        ",Print, exec, grimblast --notify --freeze copy area"

        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
        "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
        "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
        "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
        "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
        "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
        "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
        "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
        "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
        "$mainMod SHIFT, 0, movetoworkspacesilent, 10"
        "$mainMod CTRL, c, movetoworkspace, empty"

        "$mainMod SHIFT, left, movewindow, l"
        "$mainMod SHIFT, right, movewindow, r"
        "$mainMod SHIFT, up, movewindow, u"
        "$mainMod SHIFT, down, movewindow, d"
        "$mainMod CTRL, left, resizeactive, -80 0"
        "$mainMod CTRL, right, resizeactive, 80 0"
        "$mainMod CTRL, up, resizeactive, 0 -80"
        "$mainMod CTRL, down, resizeactive, 0 80"
        "$mainMod ALT, left, moveactive,  -80 0"
        "$mainMod ALT, right, moveactive, 80 0"
        "$mainMod ALT, up, moveactive, 0 -80"
        "$mainMod ALT, down, moveactive, 0 80"

        ",XF86AudioPlay,exec, playerctl play-pause"
        ",XF86AudioNext,exec, playerctl next"
        ",XF86AudioPrev,exec, playerctl previous"
        ",XF86AudioStop,exec, playerctl stop"

        "$mainMod, mouse_down, workspace, e-1"
        "$mainMod, mouse_up, workspace, e+1"

        "$mainMod, V, exec, cliphist list | rofi -dmenu -theme-str 'window {width: 50%;}' | cliphist decode | wl-copy"
      ];

      bindl =[
        ",XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        "$mainMod, XF86MonBrightnessUp, exec, brightnessctl set 100%+"
        "$mainMod, XF86MonBrightnessDown, exec, brightnessctl set 100%-"
      ];

      binde =[
        ",XF86AudioRaiseVolume,exec, pamixer -i 2"
        ",XF86AudioLowerVolume,exec, pamixer -d 2"
      ];

      bindm =[
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      windowrule =[
        "border_size 0, match:float 1"
        
        "float 1, match:class ^(qView)$"
        "center 1, match:class ^(qView)$"
        "size 1200 725, match:class ^(qView)$"
        "float 1, match:class ^(imv)$"
        "center 1, match:class ^(imv)$"
        "size 1200 725, match:class ^(imv)$"
        "float 1, match:class ^(mpv)$"
        "center 1, match:class ^(mpv)$"
        "size 1200 725, match:class ^(mpv)$"
        "tile 1, match:class ^(Aseprite)$"
        "float 1, match:title ^(float_kitty)$"
        "center 1, match:title ^(float_kitty)$"
        "size 950 600, match:title ^(float_kitty)$"
        "float 1, match:class ^(audacious)$"
        "pin 1, match:class ^(rofi)$"
        "tile 1, match:class ^(neovide)$"
        "float 1, match:class ^(udiskie)$"
        "float 1, match:title ^(Transmission)$"
        "float 1, match:title ^(Volume Control)$"
        "float 1, match:title ^(Firefox — Sharing Indicator)$"
        "move 0 0, match:title ^(Firefox — Sharing Indicator)$"
        "size 700 450, match:title ^(Volume Control)$"
        "move 40 55%, match:title ^(Volume Control)$"

        "float 1, match:title ^(Picture-in-Picture)$"
        "opacity 1.0 1.0, match:title ^(Picture-in-Picture)$"
        "pin 1, match:title ^(Picture-in-Picture)$"
        "opacity 1.0 1.0, match:title ^(.*imv.*)$"
        "opacity 1.0 1.0, match:title ^(.*mpv.*)$"
        "opacity 1.0 1.0, match:class (Aseprite)"
        "opacity 1.0 1.0, match:class (Unity)"
        "opacity 1.0 1.0, match:class (evince)"
        "workspace 5, match:class ^(Spotify)$"
        
        "float 1, match:class ^(zenity)$"
        "center 1, match:class ^(zenity)$"
        "size 850 500, match:class ^(zenity)$"
        "float 1, match:class ^(org.gnome.FileRoller)$"
        "center 1, match:class ^(org.gnome.FileRoller)$"
        "size 850 500, match:class ^(org.gnome.FileRoller)$"
        "size 850 500, match:title ^(File Upload)$"
        "float 1, match:class ^(pavucontrol)$"
        "float 1, match:class ^(SoundWireServer)$"
        "float 1, match:class ^(.sameboy-wrapped)$"
        "float 1, match:class ^(file_progress)$"
        "float 1, match:class ^(confirm)$"
        "float 1, match:class ^(dialog)$"
        "float 1, match:class ^(download)$"
        "float 1, match:class ^(notification)$"
        "float 1, match:class ^(error)$"
        "float 1, match:class ^(confirmreset)$"
        "float 1, match:title ^(Open File)$"
        "float 1, match:title ^(branchdialog)$"
        "float 1, match:title ^(Confirm to replace files)$"
        "float 1, match:title ^(File Operation Progress)$"

        "opacity 1.0 1.0, match:class ^([Zz]en.*)$"
        "workspace 1 silent, match:class ^(kitty-ws1)$"
        "workspace 2 silent, match:class ^(kitty-ws2)$"
        "workspace 1 silent, match:class ^([Aa]yu[Gg]ram.*)$"

        
        "opacity 0.0 0.0, match:class ^(xwaylandvideobridge)$"
        "no_anim 1, match:class ^(xwaylandvideobridge)$"
        "no_initial_focus 1, match:class ^(xwaylandvideobridge)$"
        "max_size 1 1, match:class ^(xwaylandvideobridge)$"
        "no_blur 1, match:class ^(xwaylandvideobridge)$"
      ];

    };

    extraConfig = "
      monitor=,preferred,auto,auto

      xwayland {
        force_zero_scaling = true
      }
    ";
  };
}
