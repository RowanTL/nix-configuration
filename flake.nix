# https://inv.nadeko.net/watch?v=JCeYq72Sko0
# This is a very nice tutorial from vimjoyer
{
  description = "Rowan's very basic flake";

  inputs = {
    nixpkgsUnstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.11";
    # home-manager.url = "github:nix-community/home-manager";
    # home-manager.inputs.nixpkgs.follows = "nixpkgs"; # Follows can drammatically reduce flake size
  };

  # very similar to Haskell name@(object) notation.
  outputs = { nixpkgs, ... } @ inputs:
  {
    nixosConfigurations.rowan-desktop = nixpkgs.lib.nixosSystem {
      # pass inputs straight to 
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
      ];
    };
  };
}
