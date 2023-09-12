{ inputs }:

({ config, lib, pkgs, ... }:

  let
    inherit (pkgs) callPackage;

    inherit (lib)
      mapAttrsToList readDir removeSuffix mkOption types mkIf length
      mkOptionType mapAttrs mkOptionDefault attrNames;

    cfg = config.theme;

    themeLib = import ../lib {
      inherit (inputs) base16;
      inherit lib pkgs;
    };

    inherit (themeLib.utils) defaultLabels;

    inherit (themeLib.types) mkDescriptorAttrset mkUniqueFixedLengthList;

    inherit (themeLib.options) mkThemeOptions;
  in {

    imports = [ ];

    options.theme = {
      themes = mkThemeOptions { inherit (config.theme.settings) labels; };
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
          type = mkUniqueFixedLengthList 16;
          default = defaultLabels;
        };

        descriptors = mkOption (let
          descriptorAttrsetType =
            mkDescriptorAttrset (config.theme.settings.labels);
        in {
          type = descriptorAttrsetType;
          description = lib.mdDoc "";
          default = descriptorAttrsetType.emptyValue;
        });
      };
    };
  })
