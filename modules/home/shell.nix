{ lib, config, pkgs, ... }:

let
  extraPassCompletions = pkgs.fetchFromGitHub {
    owner = "RowanTL";
    repo = "nushell_pass_otp_completions";
    rev = "1579c700bca760e7ce82ba9cc9a6942a01987c51";
    hash = "sha256-swpJCjdjn0wLvFyscvwM+t+UX2td9MtnMK60mmA5lrE=";
  };
  personalNuShellConfig = pkgs.fetchFromGitHub {
    owner = "RowanTL";
    repo = "nu_scripts";
    rev = "c65bb03079a6ca95e19551ba70b4dab879c4cb1b";
    hash = "sha256-slUNlKXuSMY/7qu1+4ZJ3INqmL9mDFSBtVN+5TyZg7o=";
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

    # so can use experimental nushell clip board
    home.sessionVariables = {
      NU_EXPERIMENTAL_OPTIONS="native-clip";
    };
    programs = {
      nushell = {
        enable = true;
        # gonna leave config in their respective .nu files
        configFile.source = ../non_nix/nu/config.nu;
        # Keep pass_extensions_completions.nu separate from
        # my personal nu commands as other people might actually want
        # to use pass_extensions_completions.nu
        extraConfig = ''
          source ${extraPassCompletions}/pass_extensions_completions.nu
          source ${personalNuShellConfig}/source_me.nu
        '';
      };
      carapace = {
        enable = true;
        enableNushellIntegration = true;
      };
    };
  };
}
