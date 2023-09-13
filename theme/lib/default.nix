{ lib, pkgs, base16 }:

let
  # inherit (lib) mkOption types;

  types = import ./types.nix { inherit lib utils; };
  utils = import ./utils.nix { inherit lib base16 pkgs; };
  options = import ./options.nix { inherit lib types utils; };

  inherit (options) mkThemeCommonOptions;
in {
  mkTheme = { theme, modules ? [ ] }: {
    imports = modules;
    options.theme = ((mkThemeCommonOptions { inherit theme; }) // {
      lib = lib.mkOption {
        type = lib.types.anything;
        readOnly = true;
        default = { inherit mkThemeCommonOptions; };
      };
    });
  };
}
