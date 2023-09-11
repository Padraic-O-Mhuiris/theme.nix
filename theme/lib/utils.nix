{ lib, pkgs, base16 }:

let
  inherit (pkgs) callPackage base16-schemes;

  inherit (lib) mapAttrsToList removeSuffix;

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
}
