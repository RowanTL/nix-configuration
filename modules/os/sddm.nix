{ lib, config, pkgs, ... }:

let
  infinitySddmTheme = pkgs.stdenvNoCC.mkDerivation {
    pname = "infinity-sddm-theme";
    version = "unstable-2026-02-23";

    src = pkgs.fetchFromGitHub {
      owner = "L4ki";
      repo = "Infinity-Plasma-Themes";
      rev = "e40490e79decb2f76d8e30c737bf7065f3112715";
      hash = "sha256-T2Y0EHrxNLzype41Sb9ohn5vNakLCuJa/triJrGVv9U=";
    };

    dontBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/sddm/themes
      cp -r "Infinity-SDDM/Infinity-SDDM-6" "$out/share/sddm/themes/infinity-sddm-6"
      runHook postInstall
    '';

    meta = with lib; {
      description = "Infinity SDDM theme for Plasma 6";
      homepage = "https://github.com/L4ki/Infinity-Plasma-Themes";
      license = licenses.gpl3Plus;
      platforms = platforms.linux;
    };
  };
in
{
  options = {
    sddm.enable
      = lib.mkEnableOption "enable custom sddm login manager";
  };

  config = lib.mkIf config.sddm.enable {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "infinity-sddm-6";
    };
    environment.systemPackages = [ infinitySddmTheme ];
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
