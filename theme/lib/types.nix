{ lib }:

let inherit (lib) mkOptionType length unique;
in {
  labels = mkOptionType {
    name = "base16Labels";
    description =
      "Restricted list of 16 unique string descriptors used to more intuitively reference base16 colors";
    descriptionClass = "composite";
    emptyValue = [
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
    check = list: (length list) == 16 && (length (unique list)) == 16;
  };
}
