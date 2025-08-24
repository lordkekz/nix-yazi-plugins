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
      default = '''';
    };
  };
  config = {
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
