{ lib, config, pkgs, ... }:

{
  options = {
    ly.enable
      = lib.mkEnableOption "enable custom bluetooth";
  };

  config = lib.mkIf config.bluetooth.enable {
    services.displayManager.ly.enable = true;
    security.pam.services = {
      swaylock.enableGnomeKeyring = true;
      ly.enableGnomeKeyring = true;
    };
  };
}
