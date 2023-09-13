{ inputs }:

{ config, lib, theme, pkgs, options, ... }:

{
  imports = [ ./autoload.nix ];

  options.theme =
    config.lib.theme.mkThemeCommonOptions { inherit (config) theme; };

  config.lib.theme = (import ./lib {
    inherit (inputs) base16;
    inherit lib pkgs;
  });
}
