{ inputs, lib, config, pkgs, ... }:

{
  # home-manager ships its own noctalia module now; the flake's module declares
  # the same options, so one of the two has to go.
  disabledModules = [ "programs/noctalia.nix" ];
  imports = [ inputs.noctalia.homeModules.default ];

  options = {
    home-sway.enable =
      lib.mkEnableOption "enable custom sway config";
    home-sway.enableIdle = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };

  config = lib.mkIf config.home-sway.enable {
    home.pointerCursor = {
      enable = true;
      package = pkgs.rose-pine-cursor;
      name = "BreezeX-RosePine-Linux";
      size = 24;
      gtk.enable = true;
      x11.enable = true;
      sway.enable = true;
    };

    # Sway Configuration
    # https://d19qhx4ioawdt7.cloudfront.net/docs/nix-home-manager-sway.html
    # Entirety of OP's sway configuration in nix.
    # https://git.sr.ht/~lafrenierejm/dotfiles/tree/main/item/nix/home/sway.nix
    wayland.windowManager.sway =
      let
        mod = "Mod4";
        left = "h";
        down = "n";
        up = "e";
        right = "i";
        resize_amt = "10";
        noctalia = lib.getExe config.programs.noctalia.package;
      in {
      enable = true;
      wrapperFeatures.gtk = true; # Fixes common issues with GTK 3 apps
      config = {
        modifier = mod;
        terminal = "alacritty";
        fonts = {
          size = 11.0;
        };
        defaultWorkspace = "workspace number 1";
        colors = {
          focused = {
            border = "#a277ff";
            background = "#a277ff";
            text = "#edecee";
            indicator = "#a277ff";
            childBorder = "#a277ff";
          };
          focusedInactive = {
            border = "#29263c";
            background = "#29263c";
            text = "#edecee";
            indicator = "#29263c";
            childBorder = "#29263c";
          };
          unfocused = {
            border = "#15141b";
            background = "#15141b";
            text = "#6d6d6d";
            indicator = "#15141b";
            childBorder = "#15141b";
          };
        };
        keybindings = lib.attrsets.mergeAttrsList [
          (lib.attrsets.mergeAttrsList (map (num: let
            ws = toString num;
          in {
            "${mod}+${ws}" = "workspace number ${ws}";
            "${mod}+Shift+${ws}" = "move container to workspace number ${ws}";
          }) [1 2 3 4 5 6 7 8 9]))

          (lib.attrsets.concatMapAttrs (key: direction: {
              "${mod}+${key}" = "focus ${direction}";
              "${mod}+Shift+${key}" = "move ${direction}";
            }) {
              "${left}" = "left";
              "${down}" = "down";
              "${up}" = "up";
              "${right}" = "right";
            })

          {
            # special case for workspace 10
            "${mod}+0" = "workspace number 10";
            "${mod}+Shift+0" = "move container to workspace number 10";

            "${mod}+Return" = "exec --no-startup-id ${lib.getExe pkgs.alacritty}";
            # Noctalia program launcher
            "${mod}+d" = "exec --no-startup-id ${noctalia} msg panel-toggle launcher";

            "${mod}+Shift+q" = "kill";

            "${mod}+b" = "split h";
            "${mod}+v" = "split v";
            "${mod}+a" = "focus parent";
            "${mod}+f" = "layout toggle split";
            "${mod}+s" = "layout stacking";
            "${mod}+w" = "layout tabbed";
            "${mod}+t" = "fullscreen toggle";

            "${mod}+Shift+r" = "exec swaymsg reload";
            "--release Print" = "exec --no-startup-id ${lib.getExe pkgs.flameshot} gui";
            # Noctalia lock screen
            "${mod}+l" = "exec ${pkgs.systemd}/bin/loginctl lock-session";
            "${mod}+Shift+l" = "exit";
            "${mod}+p" = "mode \"resize\"";
            # swap focus between tiling area and floating area
            "${mod}+space" = "focus mode_toggle";
            # toggle current focus between tiling and floating mode
            "${mod}+Shift+space" = "floating toggle";

            # Move focus with arrow keys
            "${mod}+Left" = "focus left";
            "${mod}+Down" = "focus down";
            "${mod}+Up" = "focus up";
            "${mod}+Right" = "focus right";
            # Move focused window with arrow keys
            "${mod}+Shift+Left" = "move left";
            "${mod}+Shift+Down" = "move down";
            "${mod}+Shift+Up" = "move up";
            "${mod}+Shift+Right" = "move right";

            # scratchpad stuff
            # Move currently focused window to the scratchpad
            "${mod}+Shift+minus" = "move scratchpad";
            # Show/hide (focused) scratchpad window. If multiple scratchpad windows,
            # cycles throught them
            "${mod}+minus" = "scratchpad show";

            # brightness and volume keybindings
            "XF86MonBrightnessDown" = "exec ${lib.getExe pkgs.brightnessctl} s 1-";
            "XF86MonBrightnessUp" = "exec ${lib.getExe pkgs.brightnessctl} s +1";
            "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +1%";
            "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -1%";
            "Shift+XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
            "Shift+XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
            "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";

            # I like having shortcuts for my browsers
            "${mod}+o" = "exec ${lib.getExe pkgs.librewolf}";
            "${mod}+Shift+o" = "exec ${lib.getExe pkgs.librewolf} --private-window about:home";
            # "${mod}+o" = "exec ${lib.getExe pkgs.floorp-bin}";
            # "${mod}+Shift+o" = "exec ${lib.getExe pkgs.floorp-bin} --private-window about:home";
            "${mod}+m" = "exec ${lib.getExe pkgs.brave}";
            "${mod}+Shift+m" = "exec ${lib.getExe pkgs.brave} --incognito";
          }
        ];
        focus.followMouse = false;
        modes = {
          resize = {
            # for n, e, i, o keys
            ${left} = "resize shrink width ${resize_amt} px";
            ${down} = "resize grow height ${resize_amt} px";
            ${up} = "resize shrink height ${resize_amt} px";
            ${right} = "resize grow width ${resize_amt} px";
            # for arrow keys
            "Left" = "resize shrink width ${resize_amt} px";
            "Down "= "resize grow height ${resize_amt} px";
            "Up" = "resize shrink height ${resize_amt} px";
            "Right" = "resize grow width ${resize_amt} px";

            # return to default mode
            "Return" = "mode \"default\"";
            "Escape" = "mode \"default\"";
          };
        };
        input = {
          "type:keyboard" = {
            "xkb_layout" = "us,us";
            "xkb_variant" = "colemak,";
            "xkb_options" = "grp:alt_shift_toggle";
          };
        };
        # noctalia draws the bar, so sway must not render one of its own
        bars = [ ];
        startup = [
          # ensures kanshi works at boot
          {
            command = "sleep 5 && systemctl --user restart kanshi";
          }
          # ensures kanshi works after a reload
          {
            command = "systemctl --user restart kanshi";
            always = true;
          }
          # bar, launcher, lock screen and idle handling. Deliberately not
          # `always`, so a reload doesn't leave a second shell running.
          {
            command = noctalia;
          }
        ];
      };
      extraConfig = ''
        include /etc/sway/config.d/*
      '';
    };

    # Needed so noctalia can update wallpaper
    # TODO: Figure this out for multiple computers/monitors.
    home.file.".config/noctalia/planet_with_ring.jpg".source = ../non_nix/wallpapers/planet_with_ring.jpg;

    programs.noctalia = {
      enable = true;

      settings = { # This may also be a string or path to a .toml file.
        theme = {
          mode = "dark";
          source = "community";
          community_palette = "Aura";
        };

        wallpaper = {
          enabled = true;
          default.path = "${config.home.homeDirectory}/.config/noctalia/planet_with_ring.jpg";
        };

        bar.main = {
          position = "top";
          thickness = 30; # bar height, default = 34
          margin_ends = 0; # left/right ends gap
          margin_edge = 0; # distance between screen edge and bar
          radius = 0; # Remove bar edges
          end = [ "media" "tray" "notifications" "clipboard" "network" "bluetooth" "volume" "brightness" "battery" "control-center" "session" ];
        };

        widget.clock = {
          format = "{:%H:%M:%S}";
        };
      }
      # replaces swayidle: noctalia arms the idle timers itself
      // lib.optionalAttrs config.home-sway.enableIdle {
        idle.behavior = {
          lock = {
            enabled = true;
            timeout = 600;
            action = "lock";
          };
          screen-off = {
            enabled = true;
            timeout = 660;
            action = "screen_off";
          };
          suspend = {
            enabled = true;
            timeout = 665;
            action = "suspend";
          };
        };
      };
    };

    home.file.".hm-graphical-session".text = pkgs.lib.concatStringsSep "\n" [
      "export MOZ_ENABLE_WAYLAND=1"
      "export NIXOS_OZONE_WL=1" # Electron
    ];
    home.sessionVariables = {
      XDG_CURRENT_DESKTOP = "sway";
      XDG_SCREENSHOTS_DIR = "~/Pictures";
      XDG_DOWNLOAD_DIR = "~/Downloads";
    };

    home.packages = with pkgs; [
      wl-clipboard
      libsForQt5.qt5ct
      libsForQt5.qtstyleplugin-kvantum
    ];
    # screenshotting software
    services.flameshot = {
      enable = true;
      settings = {
        General = {
          disabledTrayIcon = true;
        };
      };
    };
  };
}
