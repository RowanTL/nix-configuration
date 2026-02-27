{ lib, config, pkgs, ... }:

{
  imports = [
    ./pass.nix
  ];

  config = {
    environment.systemPackages = with pkgs; [
      pavucontrol
      ncdu
    ];
    pass.enable = true;
  };
}
