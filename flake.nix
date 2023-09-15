{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    base16.url = "github:SenchoPens/base16.nix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-unit.url = "github:adisbladis/nix-unit";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = { self, flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      debug = true;
      systems = inputs.nixpkgs.lib.systems.flakeExposed;

      perSystem = { config, lib, pkgs, inputs', ... }: {
        devShells.default = pkgs.mkShell {
          buildInputs = [ inputs'.nix-unit.packages.default pkgs.reflex ];
        };

        packages.default = pkgs.writeShellScriptBin "test" ''
          DFT_BACKGROUND=dark ${pkgs.reflex}/bin/reflex -r '\**/*.nix' -- ${inputs'.nix-unit.packages.default}/bin/nix-unit --flake .#tests --gc-roots-dir .nix-gc ;
        '';
      };

      flake = {
        nixosModules.theme = import ./theme/nixos {
          inherit (self) themeLibFactory;
          homeManagerModule = self.homeManagerModules.theme;
        };

        homeManagerModules.theme =
          import ./theme/hm { inherit (self) themeLibFactory; };

        inherit inputs;
        inherit (inputs.nixpkgs) lib;

        themeLibFactory = import ./lib { inherit (inputs) base16; };

        tests = import ./tests {
          inherit (inputs.nixpkgs) lib;
          nixosModule = self.nixosModules.theme;
          homeManagerModule = self.homeManagerModule.theme;
        };

        # theme = cfg:
        #   (inputs.nixpkgs.lib.nixosSystem {
        #     modules = [
        #       inputs.home-manager.nixosModules.home-manager
        #       self.nixosModules.theme
        #       {

        #         nixpkgs.hostPlatform = "x86_64-linux";

        #         users.users.user = { };
        #         home-manager.users.user = { home.stateVersion = "23.11"; };
        #       }
        #       cfg
        #     ];
        #   });

        # themeHm = cfg:
        #   (inputs.home-manager.lib.homeManagerConfiguration {
        #     pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
        #     modules = [
        #       self.homeManagerModules.theme
        #       # cfg
        #       {
        #         home.username = "user";
        #         home.homeDirectory = "/home/user";
        #         home.stateVersion = "23.11";
        #       }
        #     ];
        #   });

      };
    };
}
