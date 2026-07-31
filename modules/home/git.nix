{ lib, config, ... }:

{
  options = {
    home-git.enable
      = lib.mkEnableOption "enable custom git";
  };

  config = lib.mkIf config.home-git.enable {
    programs.git = {
      enable = true;
      lfs.enable = true;
      settings = {
        user.name = "Rowan Torbitzky-Lane";
        user.email = "rowan.a.tl@protonmail.com";
        init.defaultBranch = "main";
      };
    };
  };
}
