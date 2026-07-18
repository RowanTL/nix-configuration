{ inputs, lib, config, pkgs, ... }:

{
  options = {
    hyprland.enable
      = lib.mkEnableOption "enable hyprland os configuration";  
  };
  
  # In case there are issues stuttering, check the flakes section
  # in https://wiki.hypr.land/Nix/Hyprland-on-NixOS/
  # Is a mesa problem with a solution mentioned
  config = lib.mkIf config.hyprland.enable {
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

    environment.systemPackages = [
      # pkgs.kitty
    ];
  };
}
