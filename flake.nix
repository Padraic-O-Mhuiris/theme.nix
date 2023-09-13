{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    base16.url = "github:SenchoPens/base16.nix";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = { self, flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      debug = true;
      systems = inputs.nixpkgs.lib.systems.flakeExposed;
      flake = {
        nixosModules.theme = import ./theme { inherit inputs; };

        inherit inputs;

        theme = cfg:
          (inputs.nixpkgs.legacyPackages.x86_64-linux.nixos {
            imports = [ self.nixosModules.theme ];
            config = cfg;
          }).config.theme;

        # themeOpts = (inputs.nixpkgs.legacyPackages.x86_64-linux.nixos {
        #   imports = [ self.nixosModules.theme ];
        # }).options.theme;
      };
    };
}
