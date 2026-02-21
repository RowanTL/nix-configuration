{ lib, config, ... }:

{
  options = {
    sway.enable
      = lib.mkEnableOption "enable basic programs for sway";  
  };
  
  config = lib.mkIf config.git.enable {
    security.polkit.enable = true;
    services.gnome.gnome-keyring.enable = true;
    programs.light.enable = true;
    programs.sway.enable = true;
  };
}
