{ lib, config, ... }:

{
  options = {
    ly.enable
      = lib.mkEnableOption "enable custom ly login manager";
  };

  config = lib.mkIf config.ly.enable {
    services.displayManager.ly = {
      enable = true;
      animation = "gameoflife";
    };
    security.pam.services = {
      ly.enableGnomeKeyring = true;
    };
  };
}
