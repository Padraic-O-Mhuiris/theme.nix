{ config, lib, pkgs, ... }:

{ }

# config.theme.lib.mkThemeModule ({ colors }: {

# });

# let
#   inherit (lib) mkEnableOption attrNames mkOption types mkOptionDefault;

#   themeCfg = config.theme;

#   themeModuleCfg = config.theme.windowManager.i3;

#   colors = themeModuleCfg.colors;
# in

# {
#   options.theme.windowManager.i3 = {
#     enable = mkEnableOption "theme.windowManager.i3";
#     theme = mkOption {
#       type = types.enum (attrNames config.theme.schemes);
#       default = config.theme.theme;
#     };
#     colors = options.theme.schemes.${themeModuleCfg.theme};
#   };
# }
