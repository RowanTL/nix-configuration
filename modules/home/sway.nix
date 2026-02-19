{ lib, config, pkgs, ... }:

{
  options = {
    sway.enable =
      lib.mkEnableOption "enable custom sway config";
  };

  config = lib.mkIf config.sway.enable {
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
      in {
      enable = true;
      wrapperFeatures.gtk = true; # Fixes common issues with GTK 3 apps
      config = {
        modifier = mod;
        terminal = "alacritty"; 
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
             
            "${mod}+Return" = "exec --no-startup-id ${pkgs.alacritty}/bin/alacritty";
            "${mod}+d" = "exec --no-startup-id rofi -show drun -show-icons";

            "${mod}+Shift+q" = "kill";

            "${mod}+b" = "split h";
            "${mod}+v" = "split v";
            "${mod}+a" = "focus parent";
            "${mod}+f" = "layout toggle split";
            "${mod}+s" = "layout stacking";
            "${mod}+w" = "layout tabbed";
            "${mod}+t" = "fullscreen toggle";

            "${mod}+Shift+r" = "exec swaymsg reload";
            "--release Print" = "exec --no-startup-id ${pkgs.sway-contrib.grimshot}/bin/grimshot copy area";
            "${mod}+l" = "exec ${pkgs.swaylock-fancy}/bin/swaylock-fancy";
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
        bars = [
          {command = "${pkgs.waybar}/bin/waybar"; }
        ];
        startup = [
          # {
          #   command = "systemctl --user restart kanshi";
          #   always = true;
          # }
          # {
          #   command = "systemctl --user restart waybar";
          #   always = true;
          # }
          {
            command = "systemctl --user restart swayidle";
            always = true;
          }
          # {
          #   command = "systemctl --user restart swayr";
          #   always = true;
          # }
        ];
      };
    };
    programs.rofi = {
      enable = true;
      modes = [
        "drun"
      ];
      extraConfig = {
        show-icons = true;
      };
    };
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      settings = {
        mainbar = {
          modules-left = [
            "sway/workspaces"
            "sway/mode"
          ];
          modules-center = [
            "sway/window"
          ];
          modules-right = [
            "network"
            "battery"
            "clock"
          ];
          clock = {
            format = "{:%Y-%m-%d %H:%M}";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          };
          battery = {
            states = {
              good = 95;
              warning = 30;
              critical = 15;
            };
            format = "{capacity}%";
            format-full = "{capacity}%";
            format-charging = "{capacity}%!";
            format-plugged = "{capacity}%p";
            format-alt = "{time}";
            format-icons = [];
          };
          network = {
            format-wifi = "{essid} ({signalStrength})";
            format-ethernet = "{ipaddr}/{cidr}";
            tooltip-format = "{ifname} via {gwaddr}";
            format-linked = "{ifname} (No IP)";
            format-disconnected = "Disconnected";
            format-alt = "{ifname}: {ipaddr}/{cidr}";
          };
          workspaces = {
            sort-by-number = true;
          };
          mode = {
            format = "<span style=\"italic\">{}</span>";
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
    };

    services.swayidle = {
      enable = true;
      events = {
        "before-sleep" = "${pkgs.swaylock-fancy}/bin/swaylock-fancy -fF";
        "lock" = "lock";
      };
      timeouts = [
        {
          timeout = 600;
          command = "${pkgs.sway}/bin/swaymsg \"output * power off\"";
          resumeCommand = "${pkgs.sway}/bin/swaymsg \"output * power on\"";
        }
      ];
    };
  };
}
