{ config, lib, pkgs, ... }:

let
  inherit (lib) mkOption mdDoc;

  inherit (config.lib.theme.types) fontType;

  cfg = config.theme.fonts;
in {
  options.theme.fonts = {
    serif = mkOption {
      description = mdDoc "Serif font.";
      type = fontType;
      default = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
    };

    sansSerif = mkOption {
      description = mdDoc "Sans-serif font.";
      type = fontType;
      default = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
    };

    monospace = mkOption {
      description = mdDoc "Monospace font.";
      type = fontType;
      default = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans Mono";
      };
    };

    emoji = mkOption {
      description = mdDoc "Emoji font.";
      type = fontType;
      default = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
  };

  config = {
    fonts = {
      packages = [
        cfg.monospace.package
        cfg.serif.package
        cfg.sansSerif.package
        cfg.emoji.package
      ];

      fontconfig.defaultFonts = {
        monospace = [ cfg.monospace.name ];
        serif = [ cfg.serif.name ];
        sansSerif = [ cfg.sansSerif.name ];
        emoji = [ cfg.emoji.name ];
      };
    };
  };

}
