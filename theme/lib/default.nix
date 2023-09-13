{ lib, pkgs, base16 }:

let
  types = import ./types.nix { inherit lib utils; };
  utils = import ./utils.nix { inherit lib base16 pkgs; };
  options = import ./options.nix { inherit lib types utils; };
in {
  inherit (options) mkThemeCommonOptions mkThemeModuleCommonOptions;

  inherit types;
}
