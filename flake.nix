{
  description = "System Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hy3 = {
      url = "github:outfoxxed/hy3";
      inputs.hyprland.follows = "hyprland";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;

      config = {
        allowUnfree = true;
        nvidia.acceptLicense = true;
      };
    };

    mkSystem = name: nixpkgs.lib.nixosSystem {
      specialArgs = { inherit system; inherit inputs; };

      modules = [
        ./hosts/${name}/configuration.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit system; inherit inputs; };

          home-manager.users.rowan = import ./hosts/${name}/home.nix;
        }
      ];
    };
  in
  {
    nixosConfigurations = nixpkgs.lib.genAttrs [
      "rowan-laptop"
      "rowan-desktop"
      "rowan-server"
      "rowan-laptop-test"
    ] (name: mkSystem name);
  };
}
