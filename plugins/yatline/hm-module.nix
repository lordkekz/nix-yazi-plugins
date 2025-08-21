{
  options =
    _:
    { lib, ... }:
    {
      theme = {
        name = lib.mkOption {
          type =
            with lib.types;
            nullOr (enum [
              "catppuccin"
            ]);
          description = ''
            The name of the theme to set.
            Note that this is limited to the yatline theme plugins currently packaged.
          '';
          example = "catppuccin";
          default = null;
        };

        setup = lib.mkOption {
          type = with lib.types; either str attrs;
          description = ''
            Options to pass to theme plugin when running `setup` on it.
            Note that this is highly specific to the theme in question.
          '';
          example = "mocha";
          default = { };
        };
      };

      # NOTE: yatline has a lot of configuration options
      extraSetup = lib.mkOption {
        type = with lib.types; attrs;
        description = "Extra configuration to pass to `setup`";
        example = {
          show_background = false;
          header_line = {
            left = {
              section_a = [
                {
                  type = "line";
                  custom = false;
                  name = "tabs";
                  params = [ "left" ];
                }
              ];
            };
          };
        };
        default = { };
      };
    };
  config =
    { cfg, ... }:
    { lib, pkgs, ... }:
    let
      luaFormat = lib.generators.toLua { };
      requirePlugin = name: setup: ''
        require("${name}"):setup(${if setup != { } then luaFormat setup else ""})
      '';
      themeIsSet = !isNull cfg.theme.name;
      themeName = "yatline-${cfg.theme.name}";
    in
    {
      programs.yazi = {
        plugins = lib.mkIf themeIsSet {
          ${themeName} = pkgs.yaziPlugins.${themeName};
        };

        yaziPlugins = {
          preRequire."yatline" = lib.mkIf themeIsSet ''
            local yatline_theme = ${requirePlugin themeName cfg.theme.setup}
          '';
          require."yatline" =
            cfg.extraSetup
            // (lib.optionalAttrs themeIsSet {
              theme = if themeIsSet then (lib.generators.mkLuaInline "yatline_theme") else null;
            });
        };
      };
    };
}
