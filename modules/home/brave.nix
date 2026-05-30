{ lib, config, pkgs, ... }:

{
  options = {
    home-brave.enable
      = lib.mkEnableOption "enable brave";  
  };
  
  config = lib.mkIf config.home-brave.enable {
    home.packages = with pkgs; [
      brave
    ];
  };
}
