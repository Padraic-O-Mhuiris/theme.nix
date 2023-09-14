{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    base16.url = "github:SenchoPens/base16.nix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = { self, flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      debug = true;
      systems = inputs.nixpkgs.lib.systems.flakeExposed;
      flake = {
        nixosModules.theme = import ./theme/nixos {
          inherit (self) themeLibFactory;
          homeManagerModule = self.homeManagerModules.theme;
        };

        homeManagerModules.theme =
          import ./theme/hm { inherit (self) themeLibFactory; };

        inherit inputs;

        themeLibFactory = import ./lib { inherit (inputs) base16; };

        theme = cfg:
          (inputs.nixpkgs.lib.nixosSystem {
            modules = [
              inputs.home-manager.nixosModules.home-manager
              self.nixosModules.theme
              {

                nixpkgs.hostPlatform = "x86_64-linux";

                users.users.user = { };
                home-manager.users.user = { home.stateVersion = "23.11"; };
              }
              cfg
            ];
          });

        themeHm = cfg:
          (inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
            modules = [
              self.homeManagerModules.theme
              # cfg
              {
                home.username = "user";
                home.homeDirectory = "/home/user";
                home.stateVersion = "23.11";
              }
            ];
          });

        perSystem = { pkgs, system, ... }: {
          checks.${system}.myCheck = false;
        };
      };
    };
}
