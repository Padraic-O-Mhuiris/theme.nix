{ lib, utils, types }:

let
  inherit (lib)
    mapAttrs mkOption attrNames removeSuffix mapAttrsToList mkEnableOption;

  inherit (lib.attrsets) mergeAttrsList;

  inherit (builtins) readDir;

  mkThemeOption = label: color:
    mkOption {
      type = lib.types.str;
      default = color;
      readOnly = true;
    };

  mkBase16ThemeOption = theme: mapAttrs mkThemeOption (utils.themeAttrs theme);

  mkThemeByDescriptorsAndLabelsOption = { theme, descriptors, labels }:
    let
      themeByLabelsAttrs = (utils.themeByLabelsAttrs theme labels);

      themeByDescriptorAttrs =
        mapAttrs (k: v: themeByLabelsAttrs."${v}") descriptors;
    in mapAttrs mkThemeOption (themeByLabelsAttrs // themeByDescriptorAttrs);

  mkAllThemeOptions = { theme, ... }@args:
    (mkBase16ThemeOption theme) // (mkThemeByDescriptorsAndLabelsOption args)
    // {
      name = mkOption {
        type = lib.types.str;
        default = theme;
        readOnly = true;
      };
    };

  mkThemeSchemesOption = { settings }:
    mergeAttrsList (map (theme: {
      "${theme}" = mkAllThemeOptions {
        inherit theme;
        inherit (settings) descriptors labels;
      };
    }) utils.themeNames);

  mkThemeSchemeOption = { default, schemes }:
    mkOption {
      type = lib.types.enum (attrNames schemes);
      inherit default;
    };

  mkThemeColorsOption = { scheme, schemes }: schemes.${scheme};

  mkThemeSettingsLabelsOption = { default }:
    mkOption {
      description = lib.mdDoc ''
        Default labels for describing the base16 spectrum, index 0 through 7
        is typically black - white, 8 - 15 is typically a rainbow spectrum
        from red to violet.

        The intention behind this is to provide a more intuitive reference
        for each color beyond the hexadecimal base00 to base0F.

        Must be of length 16
      '';
      type = types.mkUniqueFixedLengthListType 16;
      inherit default;
    };

  mkThemeSettingsDescriptorsOption = { parentDescriptors, labels }:
    let type = types.mkDescriptorAttrsetType labels;
    in mkOption {
      inherit type;
      description = lib.mdDoc ''
        Descriptors are signifiers of component labels which associate to a
        certain label. Sensible defaults exist but can be extended and more
        descriptors can be added by adding a descriptor - label pair as a
        configuration type.

        This object is then used to extend descriptors to the real hexadecimal
        color values
      '';
      default = type.emptyValue // parentDescriptors;
    };

in rec {
  # This function is used for defining the globalTheme and localTheme modules;
  mkThemeCommonOptions = { theme, globalTheme ? null }:
    let schemes = mkThemeSchemesOption { inherit (theme) settings; };
    in {
      settings = {
        labels = mkThemeSettingsLabelsOption {
          default = if globalTheme == null then
            utils.defaultLabels
          else
            globalTheme.settings.labels;
        };
        descriptors = mkThemeSettingsDescriptorsOption {
          inherit (theme.settings) labels;
          parentDescriptors = if globalTheme == null then
            { }
          else
            globalTheme.settings.descriptors;
        };

        scheme = mkThemeSchemeOption {
          inherit schemes;
          default =
            if globalTheme == null then "nord" else globalTheme.settings.scheme;
        };
      };

      colors = mkThemeColorsOption {
        inherit (theme.settings) scheme;
        inherit schemes;
      };
    };

  mkThemeModuleCommonOptions = { moduleName, theme, globalTheme ? null }: {
    "${moduleName}" = ({
      enable = mkEnableOption moduleName;
    } // (mkThemeCommonOptions { inherit theme globalTheme; }));
  };
}
