{ lib, pkgs, base16 }:

let
  inherit (pkgs) callPackage base16-schemes;

  inherit (lib)
    mapAttrsToList removeSuffix zipListsWith all attrNames attrValues hasAttr
    any isAttrs unique length elemAt;

  inherit (lib.attrsets) mergeAttrsList;

  inherit (builtins) readDir;

  base16Lib = (callPackage base16.lib { });

  themesDir = "${base16-schemes.outPath}/share/themes";

  themePath = theme: "${themesDir}/${theme}.yaml";
in rec {

  themeNames =
    (mapAttrsToList (k: _: removeSuffix ".yaml" k) (readDir themesDir));

  themeAttrs = theme:
    let themeAttrset = (base16Lib.mkSchemeAttrs (themePath theme)).withHashtag;
    in {
      inherit (themeAttrset)
        base00 base01 base02 base03 base04 base05 base06 base07 base08 base09
        base0A base0B base0C base0D base0E base0F;
    };

  themeList = theme:
    let
      inherit (themeAttrs theme)
        base00 base01 base02 base03 base04 base05 base06 base07 base08 base09
        base0A base0B base0C base0D base0E base0F;
    in [
      base00
      base01
      base02
      base03
      base04
      base05
      base06
      base07
      base08
      base09
      base0A
      base0B
      base0C
      base0D
      base0E
      base0F
    ];

  themeByLabelsAttrs = theme: labels:
    mergeAttrsList (zipListsWith (label: color: { "${label}" = color; }) labels
      (themeList theme));

  defaultLabels = [
    "black"
    "charcoal"
    "graphite"
    "slate"
    "gray"
    "silver"
    "pearl"
    "white"
    "red"
    "orange"
    "yellow"
    "green"
    "aqua"
    "blue"
    "purple"
    "violet"
  ];

  # defaultDescriptors = {
  #   foreground = "silver";
  #   background = "black";
  #   primary = "charcoal";
  #   secondary = "slate";
  #   accent = "white";
  #   info = "blue";
  #   success = "green";
  #   warning = "yellow";
  #   error = "red";
  # };

  defaultDescriptors = [
    "foreground"
    "background"
    "primary"
    "secondary"
    "accent"
    "info"
    "success"
    "warning"
    "error"
  ];

  mkDefaultDescriptorAttrset = valueList: {
    foreground = elemAt valueList 6; # pearl
    background = elemAt valueList 0; # black
    primary = elemAt valueList 1; # charcoal
    secondary = elemAt valueList 3; # slate
    accent = elemAt valueList 7; # pearl
    info = elemAt valueList 13; # blue
    success = elemAt valueList 11; # green
    warning = elemAt valueList 10; # yellow
    error = elemAt valueList 8; # red
  };
}
