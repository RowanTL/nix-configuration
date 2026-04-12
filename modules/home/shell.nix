{ lib, config, pkgs, ... }:

{
  options = {
    home-shell.enable
      = lib.mkEnableOption "enable personal shell config (alacritty + nushell)";  
  };
  
  config = lib.mkIf config.home-shell.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        terminal = {
          shell = "${pkgs.nushell}/bin/nu";
        };
      };
    };

    programs.nushell = {
      enable = true;
      # gonna leave config in their respective .nu files
      configFile.source = ../non_nix/nu/config.nu;
      envFile.source = ../non_nix/nu/env.nu;
    };
  };
}
