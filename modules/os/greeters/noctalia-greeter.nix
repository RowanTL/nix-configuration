{ lib, config, inputs, pkgs, ... }:

{
  options = {
    ly.enable
      = lib.mkEnableOption "enable custom noctalia-greeter login manager";
  };

  config = lib.mkIf config.noctalia-greeter.enable {
    programs.noctalia-greeter = {
      enable = true;
      # Optional: extra flags after `--` on noctalia-greeter-session
      greeter-args = "";
      # Full declarative greeter.toml (overwritten each activation). See examples/greeter.toml.
      settings = {
        cursor = {
          theme = "Bibata-Modern-Ice";
          size = 24;
          path = "${pkgs.bibata-cursors}/share/icons";
        };
      };
    };
  };
}
