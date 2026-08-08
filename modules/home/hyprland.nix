{ inputs, lib, config, pkgs, ... }:

{
  imports = [ inputs.noctalia.homeModules.default ];

  options = {
    home-hyprland.enable
      = lib.mkEnableOption "enable custom hyprland";
  };

  config = lib.mkIf config.home-hyprland.enable {
    programs.kitty.enable = true;
    programs.hyprlock.enable = true;
    # Follow the instructions for home-manager located at:
    # https://wiki.hypr.land/Nix/Hyprland-on-Home-Manager/#using-the-home-manager-module-with-nixos
    wayland.windowManager.hyprland =
    let
      mod = "SUPER";
      left = "h";
      down = "n";
      up = "e";
      right = "i";
      resizeAmt = 10;
      # Mirrors sway's resize mode: shrink/grow the active window by
      # resizeAmt px. relative = true makes x/y a delta rather than a
      # target size.
      resizeSteps = [
        { keys = [ left "Left" ];   x = -resizeAmt; y = 0; }
        { keys = [ down "Down" ];   x = 0;          y = resizeAmt; }
        { keys = [ up "Up" ];       x = 0;          y = -resizeAmt; }
        { keys = [ right "Right" ]; x = resizeAmt;  y = 0; }
      ];
    in
    {
      enable = true;
      xwayland.enable = true;
      package = null;
      portalPackage = null;
      configType = "lua";
      settings = {
        # hy3 only takes effect once it is the active tiling algorithm.
        config = {
          general.layout = "hy3";
          input = {
            kb_layout = "us,us";
            kb_variant = "colemak,";
            kb_options = "grp:alt_shift_toggle";
          };
        };

        bind =
          # Switch workspaces with mod + [0-9], move the active node to a
          # workspace with mod + SHIFT + [0-9]. Workspace 10 maps to key 0.
          lib.concatMap (ws:
            let
              key = toString (lib.mod ws 10);
            in [
              {
                _args = [
                  "${mod} + ${key}"
                  (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = ${toString ws} })")
                ];
              }
              {
                _args = [
                  "${mod} + SHIFT + ${key}"
                  (lib.generators.mkLuaInline ''hl.plugin.hy3.move_to_workspace("${toString ws}")'')
                ];
              }
            ]) (lib.range 1 10)

          # Directional focus/move. hy3 replaces the built-in movefocus and
          # movewindow dispatchers so that groups and tabs are handled.
          ++ lib.concatLists (lib.mapAttrsToList (key: direction: [
            {
              _args = [
                "${mod} + ${key}"
                (lib.generators.mkLuaInline ''hl.plugin.hy3.move_focus("${direction}")'')
              ];
            }
            {
              _args = [
                "${mod} + SHIFT + ${key}"
                (lib.generators.mkLuaInline ''hl.plugin.hy3.move_window("${direction}")'')
              ];
            }
          ]) {
            ${left} = "left";
            ${down} = "down";
            ${up} = "up";
            ${right} = "right";
            # same, with arrow keys
            Left = "left";
            Down = "down";
            Up = "up";
            Right = "right";
          })

          # Brightness and volume. Sway bindings repeat while held; hyprland
          # binds do not unless flagged, so repeating restores that.
          # locked keeps them working while hyprlock is up.
          ++ map (step: {
            _args = [
              step.key
              (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${step.cmd}")'')
              { repeating = true; locked = true; }
            ];
          }) [
            { key = "XF86MonBrightnessDown";       cmd = "${lib.getExe pkgs.brightnessctl} s 1-"; }
            { key = "XF86MonBrightnessUp";         cmd = "${lib.getExe pkgs.brightnessctl} s +1"; }
            { key = "XF86AudioRaiseVolume";        cmd = "${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +1%"; }
            { key = "XF86AudioLowerVolume";        cmd = "${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -1%"; }
            { key = "SHIFT + XF86AudioRaiseVolume"; cmd = "${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%"; }
            { key = "SHIFT + XF86AudioLowerVolume"; cmd = "${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%"; }
          ]

          ++ [
            {
              # mute toggle, deliberately not repeating
              _args = [
                "XF86AudioMute"
                (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle")'')
                { locked = true; }
              ];
            }
            {
              _args = [
                "${mod} + Return"
                (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${lib.getExe pkgs.kitty}")'')
              ];
            }
            {
              # application launcher, driven over noctalia's IPC so it toggles
              # the already-running shell rather than spawning a new process
              _args = [
                "${mod} + D"
                (lib.generators.mkLuaInline
                  ''hl.dsp.exec_cmd("${lib.getExe config.programs.noctalia.package} msg panel-toggle launcher")'')
              ];
            }
            {
              # split h
              _args = [
                "${mod} + B"
                (lib.generators.mkLuaInline ''hl.plugin.hy3.make_group("h", { toggle = true })'')
              ];
            }
            {
              # split v
              _args = [
                "${mod} + V"
                (lib.generators.mkLuaInline ''hl.plugin.hy3.make_group("v", { toggle = true })'')
              ];
            }
            {
              # focus parent
              _args = [
                "${mod} + A"
                (lib.generators.mkLuaInline ''hl.plugin.hy3.change_focus("raise")'')
              ];
            }
            {
              # layout toggle split
              _args = [
                "${mod} + F"
                (lib.generators.mkLuaInline ''hl.plugin.hy3.change_group("opposite")'')
              ];
            }
            {
              # layout tabbed
              _args = [
                "${mod} + W"
                (lib.generators.mkLuaInline ''hl.plugin.hy3.change_group("toggletab")'')
              ];
            }
            {
              # fullscreen toggle
              _args = [
                "${mod} + T"
                (lib.generators.mkLuaInline ''hl.dsp.window.fullscreen({ action = "toggle" })'')
              ];
            }
            {
              # reload config
              _args = [
                "${mod} + SHIFT + R"
                (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("hyprctl reload")'')
              ];
            }
            {
              _args = [
                "Print"
                (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${lib.getExe pkgs.flameshot} gui")'')
                { release = true; }
              ];
            }
            {
              # lock screen
              _args = [
                "${mod} + L"
                (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${lib.getExe pkgs.hyprlock}")'')
              ];
            }
            {
              # log out
              _args = [
                "${mod} + SHIFT + L"
                (lib.generators.mkLuaInline "hl.dsp.exit()")
              ];
            }
            {
              # enter resize mode
              _args = [
                "${mod} + P"
                (lib.generators.mkLuaInline ''hl.dsp.submap("resize")'')
              ];
            }
            {
              # close focused node (closes every window in a tab group)
              _args = [
                "${mod} + SHIFT + Q"
                (lib.generators.mkLuaInline "hl.plugin.hy3.kill_active()")
                { locked = true; }
              ];
            }
            {
              # exec librewolf shortcut
              _args = [
                "${mod} + o"
                (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${lib.getExe pkgs.librewolf}")'')
              ];
            }
            {
              # exec librewolf incognito shortcut
              _args = [
                "${mod} + SHIFT + o"
                (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${lib.getExe pkgs.librewolf} --private-window about:home")'')
              ];
            }
            {
              # exec brave shortcut
              _args = [
                "${mod} + m"
                (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${lib.getExe pkgs.brave}")'')
              ];
            }
            {
              # exec brave incognito shortcut
              _args = [
                "${mod} + SHIFT + m"
                (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${lib.getExe pkgs.brave} --incognito")'')
              ];
            }
          ];
      };

      submaps.resize.settings.bind =
        lib.concatMap (step:
          map (key: {
            _args = [
              key
              (lib.generators.mkLuaInline
                "hl.dsp.window.resize({ x = ${toString step.x}, y = ${toString step.y}, relative = true })")
            ];
          }) step.keys
        ) resizeSteps
        ++ map (key: {
          # return to the default submap
          _args = [
            key
            (lib.generators.mkLuaInline ''hl.dsp.submap("reset")'')
          ];
        }) [ "Return" "Escape" ];

      plugins = [
        inputs.hy3.packages.${pkgs.stdenv.hostPlatform.system}.hy3
      ];
    };
    # Need to auto start noctalia
    systemd.user.services.noctalia = {
      Unit = {
        Description = "Noctalia shell";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = lib.getExe config.programs.noctalia.package;
        Restart = "on-failure";
        RestartSec = 3;
      };
      Install.WantedBy = [ "hyprland-session.target" ];
    };

    programs.noctalia = {
      enable = true;

      settings = { # This may also be a string or path to a .toml file.
        theme = {
          mode = "dark";
          source = "builtin";
          builtin = "Catppuccin";
        };

        # wallpaper = {
          # enabled = true;
          # default.path = "/path/to/wallpapers/wallpaper.png";
        # };
      };
    };
  };
}
