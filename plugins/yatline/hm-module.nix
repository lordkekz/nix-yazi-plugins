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

        settings = lib.mkOption {
          type = with lib.types; either str attrs;
          description = ''
            Options to pass to theme plugin.
            Note that this is highly specific to the theme in question.
          '';
          example = "mocha";
          default = { };
        };
      };

      addons = {
        githead = {
          enable = lib.mkEnableOption "Installs yatline-githead plugin";
          settings = lib.mkOption {
            type = with lib.types; attrs;
            description = "Options to pass to yatline-githead.";
            example = {
              show_branch = true;
              branch_prefix = "on";
              prefix_color = "white";
              branch_color = "blue";
              branch_symbol = "";
              branch_borders = "()";
            };
            default = { };
          };
        };
      };

      # NOTE: yatline has a lot of configuration options
      settings = lib.mkOption {
        type = with lib.types; attrs;
        description = "Extra configuration to pass to yatline's `setup`";
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
      requirePlugin = name: settings: ''
        require("${name}"):setup(${if settings != { } then luaFormat settings else ""})
      '';
      themeIsSet = !isNull cfg.theme.name;
      themeName = "yatline-${cfg.theme.name}";
      addTheme =
        settings:
        (lib.optionalAttrs themeIsSet {
          theme = if themeIsSet then (lib.generators.mkLuaInline "yatline_theme") else null;
        })
        // settings;
    in
    {
      programs.yazi = {
        plugins =
          (lib.optionalAttrs themeIsSet {
            ${themeName} = pkgs.yaziPlugins.${themeName};
          })
          // (lib.optionalAttrs cfg.addons.githead.enable {
            yatline-githead = pkgs.yaziPlugins.yatline-githead;
          });

        yaziPlugins = {
          preRequire."yatline" = lib.mkIf themeIsSet ''
            local yatline_theme = ${requirePlugin themeName cfg.theme.settings}
          '';
          require."yatline" = addTheme cfg.settings;
          postRequire."yatline" = lib.mkIf cfg.addons.githead.enable (
            requirePlugin "yatline-githead" (addTheme cfg.addons.githead.settings)
          );
        };
      };
    };
}
