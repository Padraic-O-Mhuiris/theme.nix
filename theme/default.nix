{ inputs }:

{ config, lib, pkgs, options, ... }:

(import ./lib {
  inherit (inputs) base16;
  inherit lib pkgs;
}).mkTheme { inherit (config) theme; }
