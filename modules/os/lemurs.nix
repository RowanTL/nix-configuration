{ lib, config, ... }:

{
  options = {
    lemurs.enable
      = lib.mkEnableOption "enable custom lemurs login manager";
  };

  config = lib.mkIf config.lemurs.enable {
    services.displayManager.lemurs.enable = true;
    security.pam.services = {
      lemurs.enableGnomeKeyring = true;
    };
  };
}
