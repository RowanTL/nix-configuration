# A file for intel specific configuration to increase battery life
# Configuration pulled from https://nixos.wiki/wiki/Laptop

{ lib, config, pkgs, ... }:

{
  options = {
    intel.enable
      = lib.mkEnableOption "enable laptop intel configuration";  
  };
  
  config = lib.mkIf config.intel.enable {
    services.thermald.enable = true;
  };
}
