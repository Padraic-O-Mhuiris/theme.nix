{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    base16.url = "github:SenchoPens/base16.nix";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = { self, flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (let
      inherit (inputs.nixpkgs) lib;
      systems = lib.systems.flakeExposed;

    in {
      debug = true;
      inherit systems;
      flake = {
        nixosModules.theme = import ./theme/nixos { inherit inputs; };

        inherit inputs;
        inherit lib;
        theme = cfg:
          (inputs.nixpkgs.legacyPackages.x86_64-linux.nixos {
            imports = [ self.nixosModules.theme ];
            config = cfg;
          }).config.theme;
      };
    });
}
