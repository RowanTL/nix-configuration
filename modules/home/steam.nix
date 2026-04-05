{ lib, config, ... }:

{
  options = {
    home-steam.enable
      = lib.mkEnableOption "enable custom tmux config";
  };

  config = lib.mkIf config.home-steam.enable {
    programs.steam = {
      enable = true;
      gamescopeSession = true;
    }; 
    programs.gamemode.enable = true;
  };
}
