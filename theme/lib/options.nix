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

  mkThemeByLabelsOption = theme: labels:
    mapAttrs mkThemeOption (utils.themeByLabelsAttrs theme labels);

  mkAllThemeOptions = theme: labels:
    (mkBase16ThemeOption theme) // (mkThemeByLabelsOption theme labels);

in {
  mkThemeOptions = { labels }:
    mergeAttrsList
    (map (theme: { "${theme}" = mkAllThemeOptions theme labels; })
      utils.themeNames);
}
