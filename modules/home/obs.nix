{ lib, config, pkgs, ... }:

{
  options = {
    home-obs.enable
      = lib.mkEnableOption "enable custom obs studio";
    home-obs.camera.scene = lib.mkOption {
      type = lib.types.str;
      default = "Scene";
      description = "OBS scene that contains the camera source.";
    };
    home-obs.camera.source = lib.mkOption {
      type = lib.types.str;
      default = "Camera";
      description = "Name of the camera source in that scene.";
    };
  };

  config = lib.mkIf config.home-obs.enable {
    programs.obs-studio = {
      enable = true;
      plugins = [
        pkgs.obs-studio-plugins.wlrobs
      ];
    };

    home.packages = [ pkgs.obs-cmd ];

    # Toggles the camera item over OBS's WebSocket server. For use with obs-cli.
    wayland.windowManager.sway.config.keybindings = lib.mkIf config.home-sway.enable {
      "Ctrl+Mod1+c" = "exec ${lib.getExe pkgs.obs-cmd} scene-item toggle ${lib.escapeShellArg config.home-obs.camera.scene} ${lib.escapeShellArg config.home-obs.camera.source}";
    };
  };
}
