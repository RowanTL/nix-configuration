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
          shell = "${lib.getExe pkgs.nushell}";
        };
      };
    };

    programs = {
      nushell = {
        enable = true;
        # gonna leave config in their respective .nu files
        configFile.source = ../non_nix/nu/config.nu;
      };
      carapace = {
        enable = true;
        enableNushellIntegration = true;
      };
    };
  };
}
