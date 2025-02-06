{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkOption;
  cfg = config.programs.yazi.yaziPlugins;
in
{
  options.programs.yazi.yaziPlugins = {
    enable = mkEnableOption "yaziPlugins";
    runtimeDeps = mkOption {
      type = lib.types.listOf (lib.types.either lib.types.package lib.types.str);
      description = ''
        Additional runtime packages to make available for yazi and plugins.
        To deactivate overlaying set this to `lib.mkForce []`.

        This gets set by some plugin modules.
      '';
      default = [ ];
    };
    requiredPlugins = mkOption {
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            name = mkOption {
              type = lib.types.str;
              description = "Name of the plugin to be `require`d";
              example = "relative-motions";
            };
            setup = mkOption {
              type = lib.types.nullOr lib.types.attrs;
              description = "Optional settings to pass to the plugin's `setup()` function";
              example = lib.literalExpression ''
                {
                  show_numbers = "relative_absolute";
                  show_motion = true;
                }
              '';
            };
          };
        }
      );
      description = ''
        Plugins that need to be `require`d in ~/.config/yazi/init.lua with optional setup settings.
        To deactivate automatically setting up applicable plugins, set this to `lib.mkForce []`.

        This gets set by some plugin modules.
      '';
      default = [ ];
    };
    extraConfig = mkOption {
      type = lib.types.lines;
      description = "Extra configuration lines to add to ~/.config/yazi/init.lua";
      default = '''';
    };
  };
  config = lib.mkIf (cfg.runtimeDeps != [ ]) {
    programs.yazi.package = pkgs.yazi.override {
      extraPackages = config.programs.yazi.yaziPlugins.runtimeDeps;
    };
  };
}
