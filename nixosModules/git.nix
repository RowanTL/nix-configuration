{ config, pkgs, inputs, ... }:

{
  programs.git = {
    enable = true;
    config = {
      init.defaultBranch = "main";
      user.name = "Rowan Torbitzky-Lane";
      user.email = "rowan.a.tl@protonmail.com";
      safe.directory = "/etc/nixos";    
    };
  };
}
