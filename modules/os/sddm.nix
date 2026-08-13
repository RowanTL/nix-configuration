{ lib, config, ... }:

{
  options = {
    sddm.enable
      = lib.mkEnableOption "enable custom sddm login manager";
  };

  config = lib.mkIf config.sddm.enable {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
    services.xserver.xkb = {
      layout = "us,us";
      variant = "colemak,";
      options = "grp:alt_shift_toggle";
    };
    security.pam.services = {
      sddm.enableGnomeKeyring = true;
    };
  };
}
