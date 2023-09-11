{ inputs }:

({ config, lib, pkgs, ... }:

  let
    inherit (pkgs) callPackage;

    inherit (lib)
      mapAttrsToList readDir removeSuffix mkOption types mkIf length
      mkOptionType;

    cfg = config.theme;

    themeLib = import ../lib {
      inherit (inputs) base16;
      inherit lib pkgs;
    };
  in {

    imports = [ ];

    options.theme = {
      themes = themeLib.options.mkThemeOptions {
        inherit (config.theme.settings) labels;
      };
      settings = {
        labels = mkOption {
          description = lib.mdDoc ''
            Default labels for describing the base16 spectrum, index 0 through 7
            is typically black - white, 8 - 15 is typically a rainbow spectrum
            from red to violet.

            The intention behind this is to provide a more intuitive reference
            for each color beyond the hexadecimal base00 to base0F.

            Must be of length 16
          '';
          type = themeLib.types.labels;
          default = themeLib.types.labels.emptyValue;
        };
      };
    };
  })
