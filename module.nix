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
    plugins.max-preview = mkOption {
      type = lib.types.submodule {
        options.enable = mkOption {
          type = lib.types.bool;
          default = false;
          description = "Deprecated max-preview plugin; use toggle-pane instead.";
        };
        freeformType = lib.types.attrsOf lib.types.anything;
      };
      default = { };
      description = "Deprecated max-preview plugin configuration; use toggle-pane instead.";
    };
    plugins.hide-preview = mkOption {
      type = lib.types.submodule {
        options.enable = mkOption {
          type = lib.types.bool;
          default = false;
          description = "Deprecated hide-preview plugin option; see the migration message.";
        };
        freeformType = lib.types.attrsOf lib.types.anything;
      };
      default = { };
      description = "Removed hide-preview plugin configuration.";
    };
    runtimeDeps = mkOption {
      type = lib.types.listOf (lib.types.either lib.types.package lib.types.str);
      description = ''
        Additional runtime packages to make available for yazi and plugins.
        To deactivate overlaying set this to `lib.mkForce []`.

        This gets set by some plugin modules.
      '';
      default = [ ];
    };
    require = mkOption {
      type = with lib.types; attrsOf (nullOr attrs);
      description = ''
        Plugins that need to be `require`d in ~/.config/yazi/init.lua with optional setup settings.
        To deactivate automatically setting up applicable plugins, set this to `lib.mkForce []`.

        This gets set by some plugin modules.
      '';
      default = { };
    };
    preRequire = mkOption {
      type = with lib.types; attrsOf (nullOr lines);
      description = ''
        Extra code for plugins that need something to be done before calling `require` and setting them up.
        To deactivate automatically setting up applicable plugins, set this to `lib.mkForce []`.

        This gets set by some plugin modules.
      '';
      default = { };
    };
    postRequire = mkOption {
      type = with lib.types; attrsOf (nullOr lines);
      description = ''
        Extra code for plugins that need something to be done after calling `require` and setting them up.
        To deactivate automatically setting up applicable plugins, set this to `lib.mkForce []`.

        This gets set by some plugin modules.
      '';
      default = { };
    };
    extraConfig = mkOption {
      type = lib.types.lines;
      description = "Extra configuration lines to add to ~/.config/yazi/init.lua";
      default = "";
    };
  };
  config = {
    assertions = [
      {
        assertion =
          !(cfg.plugins.max-preview.enable or false)
          && builtins.removeAttrs cfg.plugins.max-preview [ "enable" ] == { }
          && !(cfg.plugins.hide-preview.enable or false)
          && builtins.removeAttrs cfg.plugins.hide-preview [ "enable" ] == { };
        message = ''
          The `max-preview` and `hide-preview` plugins for Yazi have been removed
          in favor of `toggle-pane`. Please remove them from your Yazi wrapper config.
        '';
      }
    ];
    programs.yazi = {
      package = lib.mkIf (cfg.runtimeDeps != [ ]) (
        pkgs.yazi.override {
          extraPackages = config.programs.yazi.yaziPlugins.runtimeDeps;
        }
      );
      initLua =
        let
          luaFormat = lib.generators.toLua { };
          requirePlugin = name: setup: ''
            require("${name}"):setup(${if setup != { } then luaFormat setup else ""})
          '';
          setUpPlugin =
            name: setup:

            lib.concatStrings (
              (lib.optional (cfg.preRequire ? ${name}) cfg.preRequire.${name})
              ++ [
                (requirePlugin name setup)
              ]
              ++ (lib.optional (cfg.postRequire ? ${name}) cfg.postRequire.${name})
            );
        in
        lib.concatStrings [
          (lib.concatStrings (lib.mapAttrsToList setUpPlugin cfg.require))
          cfg.extraConfig
        ];
    };
  };
}
