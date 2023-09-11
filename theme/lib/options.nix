{ lib, utils }:

let
  inherit (lib) mapAttrs mkOption types;

  inherit (lib.attrsets) mergeAttrsList;

  mkBase16ThemeOption = theme:
    mapAttrs (k: v:
      mkOption {
        type = types.str;
        default = v;
        readOnly = true;
      }) (utils.themeAttrs theme);

in {
  mkThemeOptions = { labels }:
    mergeAttrsList
    (map (theme: { "${theme}" = mkBase16ThemeOption theme; }) utils.themeNames);
}
