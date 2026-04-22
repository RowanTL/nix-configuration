{ lib, config, pkgs, ... }:

{
  options = {
    pass.enable
      = lib.mkEnableOption "enable pass";  
  };
  
  config = lib.mkIf config.pass.enable {
    environment.systemPackages = with pkgs; [
      pinentry-curses
      (pass-wayland.withExtensions (subpkgs: with subpkgs; [
        pass-tomb
        pass-otp
      ]))
    ];
  };
}
