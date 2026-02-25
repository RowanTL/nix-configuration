{ lib, config, ... }:

{
  options = {
    sway.enable
      = lib.mkEnableOption "enable basic programs for sway";  
  };
  
  config = lib.mkIf config.sway.enable {
    security.polkit.enable = true;
    services.gnome.gnome-keyring.enable = true;
    programs.light.enable = true;
    programs.sway.enable = true;

    # Fix swayidle, kanshi, and others not finding WAYLAND_DISPLAY
    # https://github.com/NixOS/nixpkgs/issues/407700
    systemd.services.display-manager.environment.XDG_CURRENT_DESKTOP = "X-NIXOS-SYSTEMD-AWARE";
  };
}
