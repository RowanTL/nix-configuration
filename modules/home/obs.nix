{ lib, config, pkgs, ... }:

{
  options = {
    home-obs.enable
      = lib.mkEnableOption "enable custom obs studio";  
  };
  
  config = lib.mkIf config.home-obs.enable {
    programs.obs-studio = {
      enable = true;
      plugins = [
        pkgs.obs-studio-plugins.wlrobs
      ];
    };
  };
}
