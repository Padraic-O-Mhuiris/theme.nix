{ lib, pkgs, base16 }:

let
  types = import ./types.nix { inherit lib utils; };
  utils = import ./utils.nix { inherit lib base16 pkgs; };
  options = import ./options.nix { inherit lib types utils; };
in {
  inherit (options) mkThemeCommonOptions mkThemeModuleCommonOptions;

  # mkTheme = { theme, modulesPath }:
  #   let
  #     moduleFiles = mapAttrsToList (k: v: k) (readDir modulesPath);

  #     moduleNames =
  #       map (moduleFile: removeSuffix ".nix" moduleFile) moduleFiles;

  #     moduleFilePaths =
  #       map (moduleFile: modulesPath + "/${moduleFile}") moduleFiles;

  #     modules = mergeAttrsList (map (moduleName:
  #       mkThemeModuleCommonOptions {
  #         inherit moduleName;
  #         theme = theme.modules.${moduleName};
  #         globalTheme = theme;
  #       }) moduleNames);

  #   in {
  #     imports = moduleFilePaths;

  #     options.theme = ((mkThemeCommonOptions { inherit theme; }) // {

  #       inherit modules;

  #       lib = lib.mkOption {
  #         type = lib.types.anything;
  #         readOnly = true;
  #         default = { inherit mkThemeCommonOptions; };
  #       };

  #       fonts = mkFontOptions;
  #     });

  #     config = {
  #       fonts = {
  #         packages = [
  #           config.fonts.monospace.package
  #           config.fonts.serif.package
  #           config.fonts.sansSerif.package
  #           config.fonts.emoji.package
  #         ];

  #         fontconfig.defaultFonts = {
  #           monospace = [ config.fonts.monospace.name ];
  #           serif = [ config.fonts.serif.name ];
  #           sansSerif = [ config.fonts.sansSerif.name ];
  #           emoji = [ config.fonts.emoji.name ];
  #         };
  #       };
  #     };
  #   };
}
