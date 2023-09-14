{ themeLibFactory, homeManagerModule }:

{ config, lib, pkgs, options, ... }:

let inherit (lib) optionalAttrs mkOption types mkIf mkMerge;

in {
  imports = [ ../autoload.nix ../fonts.nix ];

  options.theme =
    (config.lib.theme.mkThemeCommonOptions { inherit (config) theme; }) // {
      home-manager.enable = lib.mkOption {
        description = ''
          Enable this option if you are using home-manager in your NixosConfiguration
        '';
        type = lib.types.bool;
        default = false;
      };
    };

  # Seems to be the most practical solution for internalising libs for modules
  config = mkMerge [
    { lib.theme = themeLibFactory { inherit lib pkgs; }; }
    (optionalAttrs (options ? home-manager)
      (mkIf (config.theme.home-manager.enable) {
        home-manager.sharedModules = [ homeManagerModule ];
      }))
  ];
}
