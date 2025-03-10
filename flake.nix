# https://inv.nadeko.net/watch?v=JCeYq72Sko0
# This is a very nice tutorial from vimjoyer
{
  description = "Rowan's very basic flake";

  inputs = {
    nixpkgsUnstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.11";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs"; # Follows can drammatically reduce flake size
  };

  # very similar to Haskell name@(object) notation.
  outputs = inputs @ { nixpkgs, home-manager, ... }:
  {
    # A specific configuration for my desktop.
    nixosConfigurations.rowan-desktop = nixpkgs.lib.nixosSystem {
      # Inherit takes inputs from the current scope and passes it
      # as an argument to the modules below allowing for all of the names
      # inside of inputs to be accessed.
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/desktop/configuration.nix
        ./hosts/desktop/hardware-configuration.nix
      ];
    };
    # Server config
    nixosConfigurations.roebox = nixpkgs.lib.nixosSystem {
      # pass inputs straight to 
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/roebox/configuration.nix
        ./hosts/roebox/hardware-configuration.nix
      ];
    };
    nixosConfigurations.rowan-laptop = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/laptop/configuration.nix
        ./hosts/laptop/hardware-configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          # Do I need to have a home.nix for this?
        }
      ];
    };
  };
}
