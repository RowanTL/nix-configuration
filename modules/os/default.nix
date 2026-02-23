{ lib, config, pkgs, ... }:

{
  imports = [
    ./pass.nix
  ];

  config = {
    environment.systemPackages = with pkgs; [
      pavucontrol
    ];
    pass.enable = true;
  };
}
