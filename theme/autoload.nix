{ config, lib, pkgs, ... }:

let

  inherit (lib) mapAttrsToList removeSuffix;

  inherit (lib.attrsets) mergeAttrsList;

  inherit (builtins) readDir;

  inherit (config) theme;

  inherit (config.lib.theme) mkThemeModuleCommonOptions;

  modulesPath = ../modules;

  moduleFiles = mapAttrsToList (k: v: k) (readDir modulesPath);

  moduleNames = map (moduleFile: removeSuffix ".nix" moduleFile) moduleFiles;

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

  options.theme = { inherit modules; };
}
