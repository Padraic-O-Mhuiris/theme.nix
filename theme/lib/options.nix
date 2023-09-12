{ lib, utils }:

let
  inherit (lib) mapAttrs mkOption types;

  inherit (lib.attrsets) mergeAttrsList;

  mkThemeOption = label: color:
    mkOption {
      type = types.str;
      default = color;
      readOnly = true;
    };

  mkBase16ThemeOption = theme: mapAttrs mkThemeOption (utils.themeAttrs theme);

  mkThemeByDescriptorsAndLabelsOption = theme: descriptors: labels:
    let
      themeByLabelsAttrs = (utils.themeByLabelsAttrs theme labels);

      themeByDescriptorAttrs =
        mapAttrs (k: v: themeByLabelsAttrs."${v}") descriptors;
    in mapAttrs mkThemeOption (themeByLabelsAttrs // themeByDescriptorAttrs);

  mkAllThemeOptions = theme: descriptors: labels:
    (mkBase16ThemeOption theme)
    // (mkThemeByDescriptorsAndLabelsOption theme descriptors labels);

in {
  mkThemeOptions = { labels, descriptors }:
    mergeAttrsList
    (map (theme: { "${theme}" = mkAllThemeOptions theme descriptors labels; })
      utils.themeNames);
}
