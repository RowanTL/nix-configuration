{ pkgs, ... }:

{
  imports = [
    ./pass.nix
    ./tmux.nix
  ];

  config = {
    # cache to speed up package building
    nix.settings = {
      substituters = [
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
      ];

      trusted-substituters = [
        "https://hyprland.cachix.org"
      ];

      extra-substituters = [ "https://noctalia.cachix.org" ];

      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];

      extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];

      trusted-users = [ "root" "@wheel" ];
    };

    environment.systemPackages = with pkgs; [
      pavucontrol
      ncdu
      wget
    ];
    pass.enable = true;
    tmux.enable = true;

    programs.nix-ld.enable = true;
  };
}
