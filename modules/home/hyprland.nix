{ inputs, lib, config, pkgs, ... }:

{
  options = {
    home-hyprland.enable
      = lib.mkEnableOption "enable custom hyprland";
  };

  config = lib.mkIf config.home-hyprland.enable {
    programs.kitty.enable = true;
    # Follow the instructions for home-manager located at:
    # https://wiki.hypr.land/Nix/Hyprland-on-Home-Manager/#using-the-home-manager-module-with-nixos
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      package = null;
      portalPackage = null;
      settings = {
        mod = {
          _var = "SUPER";
        };
        bind = [
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + Q\"")
              (lib.generators.mkLuaInline "hl.dsp.window.close()")
              { locked = true; }
            ];
          }
        ];
      };
      plugins = [
        inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hy3
      ];
    };
  };
}
