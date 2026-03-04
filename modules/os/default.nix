{ lib, config, pkgs, ... }:

{
  imports = [
    ./pass.nix
    ./tmux.nix
  ];

  config = {
    # cache to speed up package building
    nix.settings.substituters = [
      "https://nix-community.cachix.org"
    ];

    nix.settings.trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];

    environment.systemPackages = with pkgs; [
      pavucontrol
      ncdu
      wget
    ];
    pass.enable = true;
    tmux.enable = true;
  };
}
