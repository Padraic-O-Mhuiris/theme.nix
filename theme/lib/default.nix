{ lib, pkgs, base16 }:

let
  inherit (lib) mapAttrsToList removeSuffix;

  inherit (lib.attrsets) mergeAttrsList;

  inherit (builtins) readDir;

  types = import ./types.nix { inherit lib utils; };
  utils = import ./utils.nix { inherit lib base16 pkgs; };
  options = import ./options.nix { inherit lib types utils; };

  inherit (options) mkThemeCommonOptions mkThemeModuleCommonOptions;

in {
  mkTheme = { theme, modulesPath }:
    let
      moduleFiles = mapAttrsToList (k: v: k) (readDir modulesPath);

      moduleNames =
        map (moduleFile: removeSuffix ".nix" moduleFile) moduleFiles;

      moduleFilePaths =
        map (moduleFile: modulesPath + "/${moduleFile}") moduleFiles;

      modules = mergeAttrsList (map (moduleName:
        mkThemeModuleCommonOptions {
          inherit moduleName;
          theme = theme.modules.${moduleName};
          globalTheme = theme;
        }) moduleNames);

    in {
      imports = moduleFilePaths;

      options.theme = ((mkThemeCommonOptions { inherit theme; }) // {
        lib = lib.mkOption {
          type = lib.types.anything;
          readOnly = true;
          default = { inherit mkThemeCommonOptions; };
        };
        inherit modules;
      });
    };
}
