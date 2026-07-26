{ lib, config, ... }:

{
  options = {
    regreet.enable
      = lib.mkEnableOption "enable custom regreet login manager";
  };

  config = lib.mkIf config.regreet.enable {
    programs.regreet = {
      enable = true;
    };
    security.pam.services = {
      regreet.enableGnomeKeyring = true;
    };
  };
}
