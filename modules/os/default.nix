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
    ];
    pass.enable = true;
    tmux.enable = true;
  };
}
