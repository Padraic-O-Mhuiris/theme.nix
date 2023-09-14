{ themeLibFactory }:

{ config, lib, pkgs, ... }@hmArgs:

let
  inherit (lib) mkMerge mkIf;

  # use this to delineate between homeManager modules called in
  # nixosConfiguration and homeConfigurations contexts
  isHmConfiguration = (hmArgs ? nixosConfig);

  l = themeLibFactory { inherit lib pkgs; };

in { }
#   mkMerge [({
#   options.theme = (l.mkThemeCommonOptions { inherit (config) theme; });
# })
# # { config.lib.theme = themeLibFactory { inherit lib pkgs; }; }
# ]
