{ lib, config, pkgs, ... }:

{
  options = {
    sway.enable
      = lib.mkEnableOption "enable basic programs for sway";
  };

  config = lib.mkIf config.sway.enable {
    security.polkit.enable = true;
    security.pam.services.swaylock.enableGnomeKeyring = true;
    services.gnome.gnome-keyring.enable = true;
    programs.sway = {
      enable = true;
      # package = pkgs.swayfx;
    };
    environment.systemPackages = with pkgs; [
      pulseaudio
      brightnessctl # light is no longer maintained :(
    ];

    # Fix swayidle, kanshi, and others not finding WAYLAND_DISPLAY
    # https://github.com/NixOS/nixpkgs/issues/407700
    systemd.services.display-manager.environment.XDG_CURRENT_DESKTOP = "X-NIXOS-SYSTEMD-AWARE";

    # So sway can use xdg-open
    xdg.portal = {
      enable = true;
      wlr = {
        enable = true;
        # The default output choosers (wmenu/wofi/rofi) aren't on the portal
        # service's PATH, so screen sharing silently fails without this.
        settings.screencast = {
          chooser_type = "simple";
          chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
        };
      };
      extraPortals = [
        pkgs.xdg-desktop-portal-wlr
      ];
    };

    services.pipewire = {
      enable = true;
      wireplumber.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
