{ lib, config, pkgs, ... }:

{
  config = {
    environment.systemPackages = with pkgs; [
      pavucontrol
    ];
  };
}
