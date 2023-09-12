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

    themes =
      mkThemeOptions { inherit (config.theme.settings) labels descriptors; };
  in {

    imports = [ ];

    options.theme = {
      schemes = themes; # TODO Make extensible

      theme = mkOption {
        type = types.enum (attrNames config.theme.schemes);
        default = "nord";
      };

      color = themes.${config.theme.theme};

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
          description = lib.mdDoc ''
            Descriptors are signifiers of component labels which associate to a
            certain label. Sensible defaults exist but can be extended and more
            descriptors can be added by adding a descriptor - label pair as a
            configuration type.

            This object is then used to extend descriptors to the real
            hexadecimal color values
          '';
          default = descriptorAttrsetType.emptyValue;
        });
      };
    };
  })
