{ lib, homeManagerModule, nixosModule }@testArgs:

let
  utils = import ./utils.nix testArgs;
  cfg = (lib.nixosSystem {
    modules = [ nixosModule { nixpkgs.hostPlatform = "x86_64-linux"; } ];
  }).config;
in {
  nixosModule.theme = {
    defaults = {
      test__home-manager_enable = {
        expr = cfg.theme.home-manager.enable;
        expected = false;
      };
      colors = {
        test__colors_name = {
          expr = cfg.theme.colors.name;
          expected = cfg.theme.settings.scheme;
        };
      };
      settings = {
        test__scheme = {
          expr = cfg.theme.settings.scheme;
          expected = "nord";
        };
        test__labels = {
          expr = cfg.theme.settings.labels;
          expected = [
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
        };
        test__descriptors = {
          expr = cfg.theme.settings.descriptors;
          expected = {
            foreground = "pearl";
            background = "black";
            primary = "charcoal";
            secondary = "slate";
            tertiary = "violet";
            info = "blue";
            success = "green";
            warning = "yellow";
            error = "red";
          };
        };
      };
    };
  };
}
