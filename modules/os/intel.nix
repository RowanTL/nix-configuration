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

    # Panel Self Refresh causes "Atomic commit failed: Device or resource
    # busy" / "Page-flip failed on eDP-1" under sway, which stalls frame
    # delivery and freezes OBS screen capture mid-recording. Costs a bit of
    # battery when the screen is static.
    boot.kernelParams = [ "i915.enable_psr=0" ];
  };
}
