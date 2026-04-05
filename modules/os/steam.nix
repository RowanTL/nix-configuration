{ lib, config, ... }:

{
  options = {
    steam.enable
      = lib.mkEnableOption "enable custom tmux config";
  };

  config = lib.mkIf config.steam.enable {
    programs.steam = {
      enable = true;
      gamescopeSession = true;
    }; 
    programs.gamemode.enable = true;
  };
}
