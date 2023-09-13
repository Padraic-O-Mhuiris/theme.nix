{ inputs }:

{ config, lib, theme, pkgs, options, ... }:

{
  imports = [ ./autoload.nix ./fonts.nix ];

  options.theme =
    config.lib.theme.mkThemeCommonOptions { inherit (config) theme; };

  # Seems to be the most practical solution for internalising libs for modules
  config.lib.theme = (import ./lib {
    inherit (inputs) base16;
    inherit lib pkgs;
  });
}
