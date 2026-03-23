{
  description = "System Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;

      config = {
        allowUnfree = true;
      };
    };

    mkSystem = name: nixpkgs.lib.nixosSystem {
      specialArgs = { inherit system; };

      modules = [
        ./hosts/${name}/configuration.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.rowan = import ./hosts/${name}/home.nix;
        }
      ];
    };
  in
  {
    nixosConfigurations = nixpkgs.lib.genAttrs [ "rowan-laptop" "rowan-desktop" "rowan-server" "rowan-laptop-test" ] (name: mkSystem name);
  };
}
