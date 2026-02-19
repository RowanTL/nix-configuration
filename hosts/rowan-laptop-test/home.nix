{ lib, config, pkgs, ... }:

# Thanks to this tutorial
# https://nixos-and-flakes.thiscute.world/nixos-with-flakes/start-using-home-manager
{
  imports = [
    ./../../modules/home/helix.nix
    ./../../modules/home/git.nix
    ./../../modules/home/ssh.nix
  ];

  home.username = "rowan";
  home.homeDirectory = "/home/rowan";

  # Also set here just in case
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Import files from the current configuration directory into the Nix store,
  # and create symbolic links pointing to those store files in the Home directory.

  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # Import the scripts directory into the Nix store,
  # and recursively generate symbolic links in the Home directory pointing to the files in the store.
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # set cursor size and dpi for 4k monitor
  # xresources.properties = {
    # "Xcursor.size" = 16;
    # "Xft.dpi" = 172;
  # };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # here is some command line tools I use frequently
    # feel free to add your own or remove some of them

    neofetch
    brave

    # archives
    zip
    xz
    unzip
    p7zip

    # misc
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    # productivity
    glow # markdown previewer in terminal

    btop  # replacement of htop/nmon

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
    unixtools.net-tools
  ];

  programs.librewolf = {
    enable = true;
    # Can add extra config here if wanted
    # https://nixos.wiki/wiki/Librewolf
  };

  # alacritty - a cross-platform, GPU-accelerated terminal emulator
  programs.alacritty = {
    enable = true;
    # custom settings
    # settings = {
      # env.TERM = "xterm-256color";
      # font = {
        # size = 12;
        # draw_bold_text_with_bright_colors = true;
      # };
      # scrolling.multiplier = 5;
      # selection.save_to_clipboard = true;
    # };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    # TODO add your custom bashrc here
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin"
    '';

    # set some aliases, feel free to add more or remove some
    # shellAliases = {
    # };
  };

  # Enable my custom configs
  helix.enable = true;
  git.enable = true;
  ssh.enable = true;

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
    config = rec {
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
          format-ethernet = "{essid}/{cidr}";
          tooltip-format = "{ifname} via {gwaddr}";
          format-linked = "{ifname} (No IP)";
          format-disconnected = "Disconnected";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };
        workspaces = {
          sort-by-number = true;
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
    EDITOR = "hx";
    SUDO_EDITOR = "hx";
  };

  # don't really need this at the moment
  # services.kanshi = {
  #   enable = true;
  # };

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

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.11";
}
