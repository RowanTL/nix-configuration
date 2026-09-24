{ lib, config, pkgs, ... }:

{
  options = {
    home-brave.enable
      = lib.mkEnableOption "enable brave";
    home-brave.package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.brave-origin.override {
        commandLineArgs = "--no-default-browser-check";
      };
      description = "The brave package to install and reference elsewhere.";
    };
  };

  config = lib.mkIf config.home-brave.enable {
    home.packages = [ config.home-brave.package ];
  };
}
