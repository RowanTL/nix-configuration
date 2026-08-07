{ inputs, lib, config, pkgs, ... }:

{
  options = {
    hyprland.enable
      = lib.mkEnableOption "enable hyprland os configuration";
  };

  # In case there are issues stuttering, check the flakes section
  # in https://wiki.hypr.land/Nix/Hyprland-on-NixOS/
  # Is a mesa problem with a solution mentioned
  config = lib.mkIf config.hyprland.enable {
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

    # programs.hyprland already pulls in polkit, the xdg portal, and a pam
    # entry for swaylock, but not one for hyprlock.
    security.pam.services.hyprlock.enableGnomeKeyring = true;
    services.gnome.gnome-keyring.enable = true;

    environment.systemPackages = with pkgs; [
      brightnessctl # light is no longer maintained :(
    ];

    # Fix hypridle, kanshi, and others not finding WAYLAND_DISPLAY
    # https://github.com/NixOS/nixpkgs/issues/407700
    systemd.services.display-manager.environment.XDG_CURRENT_DESKTOP = "X-NIXOS-SYSTEMD-AWARE";

    services.pipewire = {
      enable = true;
      wireplumber.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
