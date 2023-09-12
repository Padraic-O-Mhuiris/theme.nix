{ lib, utils }:

let
  inherit (lib)
    mkOptionType length unique mapAttrsToList all attrNames attrValues hasAttr
    any isAttrs;

  inherit (lib.attrsets) mergeAttrsList;

  inherit (builtins) genList toString;

  inherit (utils) mkDefaultDescriptorAttrset defaultDescriptors;

in {
  mkUniqueFixedLengthList = len:
    mkOptionType {
      name = "FiniteList${toString len}";
      description = "List of length ${toString len} containing unique values";
      check = list: length (unique list) == len;
      emptyValue = genList (_: null) len;
    };

  mkDescriptorAttrset = labelList:
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
      merge = loc: defs:
        mergeAttrsList
        ([ defaultDescriptorAttrset ] ++ (map (v: v.value) defs));
      emptyValue = defaultDescriptorAttrset;
    };
}
