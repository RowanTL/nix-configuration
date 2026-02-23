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
    # https://discourse.nixos.org/t/finally-got-pass-otp-bash-completions/48627
    programs.bash.interactiveShellInit = ''
      . ${pkgs.pass.extensions.pass-otp}/share/bash-completion/completions/pass-otp
    '';
  };
}
