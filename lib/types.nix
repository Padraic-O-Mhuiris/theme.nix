{ lib, utils }:

let
  inherit (lib)
    mkOptionType length unique mapAttrsToList all attrNames attrValues hasAttr
    any isAttrs types mkOption mdDoc;

  inherit (lib.attrsets) mergeAttrsList;

  inherit (builtins) genList toString;

  inherit (utils) mkDefaultDescriptorAttrset defaultDescriptors;

in {
  mkUniqueFixedLengthListType = len:
    mkOptionType {
      name = "FiniteList${toString len}";
      description = "List of length ${toString len} containing unique values";
      check = list: length (unique list) == len;
      emptyValue = genList (_: null) len;
    };

  mkDescriptorAttrsetType = labelList:
    let defaultDescriptorAttrset = mkDefaultDescriptorAttrset labelList;
    in mkOptionType {
      name = "ConstrainedAttrset";
      description = ''
        Constrained Attrset:
          - Will always contain at least ${toString defaultDescriptors} keys
          - Only entries in valueList are valid attrset values
          - More keys can be added
      '';
      check = descAttr:
        all (val: any (l: val == l) labelList) (attrValues descAttr);
      # Always ensures the defaultDescriptorAttrset exists
      merge = loc: defs:
        mergeAttrsList
        ([ defaultDescriptorAttrset ] ++ (map (v: v.value) defs));
      emptyValue = defaultDescriptorAttrset;
    };

  fontType = types.submodule {
    options = {
      package = mkOption {
        description = mdDoc "Package providing the font.";
        type = types.package;
      };

      name = mkOption {
        description = mdDoc "Name of the font within the package.";
        type = types.str;
      };
    };
  };
}
