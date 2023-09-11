{ lib, pkgs, base16 }:

rec {
  types = import ./types.nix { inherit lib; };

  utils = import ./utils.nix { inherit lib base16 pkgs; };

  options = import ./options.nix { inherit lib utils; };
}
