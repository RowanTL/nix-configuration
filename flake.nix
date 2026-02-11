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
  in
  {
    nixosConfigurations = {
      rowan-server = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit system; };

        modules = [
          ./hosts/rowan-server/configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.rowan = import ./hosts/rowan-server/home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
        ];
      };
      rowan-laptop-test = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit system; };

        modules = [
          ./hosts/rowan-laptop-test/configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.rowan = import ./hosts/rowan-laptop-test/home.nix;
          }
        ];
      };
    };
  };
}
