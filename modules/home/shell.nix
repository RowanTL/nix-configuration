{ lib, config, pkgs, ... }:

let
  extraPassCompletions = pkgs.fetchFromGitHub {
    owner = "RowanTL";
    repo = "nushell_pass_otp_completions";
    rev = "1579c700bca760e7ce82ba9cc9a6942a01987c51";
    hash = "sha256-swpJCjdjn0wLvFyscvwM+t+UX2td9MtnMK60mmA5lrE=";
  };
in
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
        extraConfig = ''
          source ${extraPassCompletions}/pass_extensions_completions.nu
        '';
      };
      carapace = {
        enable = true;
        enableNushellIntegration = true;
      };
    };
  };
}
