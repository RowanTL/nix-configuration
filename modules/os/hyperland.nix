{ lib, config, hyprland, pkgs, ... }:

{
  options = {
    hyprland.enable
      = lib.mkEnableOption "enable hyprland os configuration";  
  };
  
  config = lib.mkIf config.hyprland.enable {
    programs.hyprland = {
      enable = true;
      package = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };
  };

  environment.systemPackages = [
    # pkgs.kitty
  ];
}
