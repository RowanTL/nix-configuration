{ lib, config, ... }:

{
  options = {
    steam.enable
      = lib.mkEnableOption "enable custom steam config";
  };

  config = lib.mkIf config.steam.enable {
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
    }; 
    programs.gamemode.enable = true;
  };
}
