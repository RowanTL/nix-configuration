# https://inv.nadeko.net/watch?v=JCeYq72Sko0
# This is a very nice tutorial from vimjoyer
{
  description = "Rowan's flake";

  inputs = {
    # nixpkgsUnstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.11";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs"; # Follows can drammatically reduce flake size
  };

  # very similar to Haskell name@(object) notation.
  outputs = inputs @ { nixpkgs, home-manager, ... }:
  let
    home-manager-module = inputs.home-manager.nixosModules.default;
  in 
  {
    nixosConfigurations.rowan-desktop = nixpkgs.lib.nixosSystem {
      # Inherit takes inputs from the current scope and passes it
      # as an argument to the modules below allowing for all of the names
      # inside of inputs to be accessed.
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/desktop/configuration.nix
      ];
    };
    # Server config
    nixosConfigurations.roebox = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/roebox/configuration.nix
      ];
    };
    nixosConfigurations.rowan-laptop = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/laptop/configuration.nix
        home-manager-module
      ];
    };
  };
}
