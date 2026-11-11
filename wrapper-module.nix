{
  lib,
  pkgs,
  plugins,
  baseWrapper,
}:
{ config, wlib, ... }:
let
  pluginNames = builtins.attrNames plugins;
  yaziVersion = config.package.version or "0";

  moduleArgsFor =
    name: cfg:
    (import ./lib.nix {
      baseOptionPath = [
        "yaziPlugins"
        name
      ];
      inherit yaziVersion;
    } { inherit lib; })
    // {
      inherit cfg yaziVersion;
    };

  pluginOptions = lib.genAttrs pluginNames (
    name:
    let
      plugin = plugins.${name};
      hmModule = plugin."hm-module" or { };
      defaultPackage = lib.attrByPath [ "yaziPlugins" name ] (plugin.package or null) pkgs;
      pluginOptionModule =
        if hmModule ? options then
          hmModule.options (moduleArgsFor name { }) {
            inherit lib pkgs;
            config = {
              home.homeDirectory = config.homeDirectory;
            };
          }
        else
          { };
      extraOptions = lib.attrByPath [
        "options"
        "programs"
        "yazi"
        "yaziPlugins"
        "plugins"
        name
      ] { } pluginOptionModule;
    in
    {
      enable = lib.mkEnableOption "the Yazi ${name} plugin";
      package = lib.mkOption {
        type = lib.types.nullOr lib.types.package;
        default = defaultPackage;
        description = "The ${name} plugin package to use.";
      };
      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Extra Lua configuration for the ${name} plugin.";
      };
    }
    // extraOptions
  );

  moduleConfigFor =
    name: plugin:
    let
      hmModule = plugin."hm-module" or { };
      cfg = config.yaziPlugins.${name};
      moduleArgs = moduleArgsFor name cfg;
      pluginConfig =
        if hmModule ? config then
          (hmModule.config moduleArgs) {
            inherit lib pkgs;
            config = { };
          }
        else
          { };
    in
    {
      config = lib.mkIf cfg.enable (
        lib.mkMerge [
          pluginConfig
          {
            programs.yazi.plugins.${name} =
              if cfg.package == null then
                throw "yaziWithPlugins: plugin `${name}` is enabled but has no package; set yaziPlugins.${name}.package"
              else
                cfg.package;
          }
        ]
      );
    };

  # This recursive type gives the imported Home Manager plugin modules the
  # same useful merge behaviour for nested settings and list-valued options.
  recursiveAttrs = lib.types.attrsOf (
    lib.types.oneOf [
      lib.types.package
      lib.types.path
      lib.types.str
      lib.types.bool
      lib.types.int
      lib.types.float
      (lib.types.nullOr lib.types.bool)
      (lib.types.listOf lib.types.anything)
      recursiveAttrs
    ]
  );

  evaluated = lib.evalModules {
    modules = [
      {
        options.programs = lib.mkOption {
          type = recursiveAttrs;
          default = { };
        };
      }
    ] ++ (lib.mapAttrsToList moduleConfigFor plugins);
  };

  yaziConfig = evaluated.config.programs.yazi or { };
  yaziPlugins = yaziConfig.yaziPlugins or { };
  settings = yaziConfig.settings or { };
  keymap = yaziConfig.keymap or { };
  pluginExtraConfig = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (_: cfg: cfg.extraConfig) (
      lib.filterAttrs (_: cfg: cfg.enable) config.yaziPlugins
    )
  );

  luaFormat = lib.generators.toLua { };
  expandHome =
    value:
    if builtins.isString value && lib.hasPrefix "$HOME" value then
      let
        suffix = builtins.substring 5 (builtins.stringLength value - 5) value;
      in
      lib.generators.mkLuaInline "os.getenv(\"HOME\") .. ${luaFormat suffix}"
    else if builtins.isAttrs value && !(value ? _type) then
      lib.mapAttrs (_: v: expandHome v) value
    else if builtins.isList value then
      map expandHome value
    else
      value;
  requirePlugin = name: setup: ''
    require("${name}"):setup(${if setup != { } then luaFormat (expandHome setup) else ""})
  '';
  setupPlugin =
    name: setup:
    lib.concatStrings (
      (lib.optional (builtins.hasAttr name (
        yaziPlugins.preRequire or { }
      )) yaziPlugins.preRequire.${name})
      ++ [ (requirePlugin name setup) ]
      ++ (lib.optional (builtins.hasAttr name (
        yaziPlugins.postRequire or { }
      )) yaziPlugins.postRequire.${name})
    );
  initLua = lib.concatStrings [
    (lib.concatStrings (lib.mapAttrsToList setupPlugin (yaziPlugins.require or { })))
    (yaziPlugins.extraConfig or "")
    pluginExtraConfig
  ];

  configuredRuntimeDeps = yaziPlugins.runtimeDeps or [ ];
  runtimePkgs = lib.filter lib.isDerivation configuredRuntimeDeps;
  starshipPkgs = lib.optional (lib.attrByPath [
    "starship"
    "enable"
  ] false evaluated.config.programs) pkgs.starship;
in
{
  imports = [ baseWrapper ];

  options = {
    homeDirectory = lib.mkOption {
      type = lib.types.str;
      default = "$HOME";
      description = ''
        Home directory used for defaults in plugins that store persistent data.
        The default `$HOME` is expanded at runtime in plugin Lua configuration.
      '';
    };

    yaziPlugins = pluginOptions;
  };

  config = {
    settings = {
      yazi = settings;
      keymap = keymap;
      theme = yaziConfig.theme or { };
      vfs = yaziConfig.vfs or { };
      package = yaziConfig.package or { };
    };
    plugins = yaziConfig.plugins or { };
    # Preserve the upstream `initLua` option, which accepts either Lua text or
    # a linkable file, while placing plugin setup before the user's init code.
    constructFiles.initlua = lib.mkIf (initLua != "") {
      relPath = lib.mkOverride 0 "${config.binName}-config/init.lua";
      output = lib.mkOverride 0 config.generatedConfig.output;
      content = lib.mkForce (
        initLua
        + (
          if config.initLua == null then
            ""
          else if wlib.types.linkable.check config.initLua then
            ''

              dofile(${luaFormat (toString config.initLua)})
            ''
          else
            "\n" + config.initLua
        )
      );
      builder = lib.mkForce ''cp "$1" "$2"'';
    };
    runtimePkgs = lib.unique (runtimePkgs ++ starshipPkgs);
  };
}
