{ lib, config, pkgs, ... }:

{
  imports = [
    ./pass.nix
    ./tmux.nix
  ];

  config = {
    environment.systemPackages = with pkgs; [
      pavucontrol
      ncdu
      wget
    ];
    pass.enable = true;
    tmux.enable = true;
  };
}
