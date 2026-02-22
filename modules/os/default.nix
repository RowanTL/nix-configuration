{ lib, config, ... }:

{
  config = {
    environment.systemPackages = with pkgs; [
      pavucontrol
    ];
  }
}
