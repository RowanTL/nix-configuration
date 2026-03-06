{ lib, config, pkgs, ... }:

{
  options = {
    bluetoothe.enable
      = lib.mkEnableOption "enable custom bluetooth";
  };

  config = lib.mkIf config.bluetooth.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    }; 
    environment.systemPackages = with pkgs; [
      bluetuith
    ];
  };
}
