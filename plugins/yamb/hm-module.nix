{
  options =
    {
      cfg,
      mkKeyOption,
      ...
    }:
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      hotkeys = {

        save = mkKeyOption {
          on = [
            "u"
            "a"
          ];
          run = "plugin yamb save";
          desc = "Add bookmark";
        };
        jump = mkKeyOption {
          on = [
            "u"
            "g"
          ];
          run = "plugin yamb jump_by_key";
          desc = "Jump bookmark by key";
        };
        jumpByFzf = mkKeyOption {
          on = [
            "u"
            "G"
          ];
          run = "plugin yamb jump_by_fzf";
          desc = "Jump bookmark by fzf";
        };
        delete = mkKeyOption {
          on = [
            "u"
            "d"
          ];
          run = "plugin yamb delete_by_key";
          desc = "Delete bookmark by key";
        };
        deleteByFzf = mkKeyOption {
          on = [
            "u"
            "D"
          ];
          run = "plugin yamb delete_by_fzf";
          desc = "Delete bookmark by fzf";
        };
        deleteAll = mkKeyOption {
          on = [
            "u"
            "A"
          ];
          run = "plugin yamb delete_all";
          desc = "Delete all bookmarks";
        };
        rename = mkKeyOption {
          on = [
            "u"
            "r"
          ];
          run = "plugin yamb rename_by_key";
          desc = "Rename bookmark by key";
        };
        renameByFzf = mkKeyOption {
          on = [
            "u"
            "R"
          ];
          run = "plugin yamb rename_by_fzf";
          desc = "Rename bookmark by fzf";
        };
      };
      bookmarks = lib.mkOption {
        type =
          with lib.types;
          listOf (submodule {
            options = {
              tag = lib.mkOption {
                type = with lib.types; str;
                description = "A Tag / Name for a bookmark";
              };
              path = lib.mkOption {
                type = with lib.types; either str path;
                description = "The path of the bookmarked item";
              };
              key = lib.mkOption {
                type = with lib.types; strMatching "^.$"; # single char
                description = "A shortcut to jump to the bookmarks quickly";
              };
            };
          });
        description = "Declarative bookmarks for yamb";
        example = [
          {
            tag = "Desktop";
            path = "$HOME/Deskop";
            key = "d";
          }
        ];
        default = [ ];
      };
      jump_notify = lib.mkOption {
        type = with lib.types; bool;
        description = "Recieve notification everytime you jump.";
        default = true;
      };
      cli = lib.mkOption {
        type = with lib.types; either package str;
        description = "The CLI for fzf: either a string containing the command to be executed, or package containing an executable. If this option is a package, the package will be included as a runtime dependancy for yamb and the executable in the package will be used as the CLI command.";
        example = [
          "fzf"
          pkgs.fzf
        ];
        default = pkgs.fzf;
      };
      keys = lib.mkOption {
        type = with lib.types; separatedString "";
        description = "A string used for randomly generating keys, where the preceding characters have higher priority";
        default = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
      };
      path = lib.mkOption {
        type = with lib.types; nullOr str;
        description = "The path of bookmarks";
        default = "${config.home.homeDirectory}/.config/yazi/bookmark";
      };
    };
  config =
    {
      cfg,
      setKeys,
      ...
    }:
    { lib, pkgs, ... }:
    let
      yambConfig = lib.attrsets.filterAttrs (name: val: val != null && name != "hotkeys") cfg;
    in
    lib.mkMerge [
      (setKeys cfg.hotkeys)
      {
        programs.yazi.yaziPlugins = {
          # yambConfig.cli is either string or package:
          # if string, just insert the option
          # if package, add it to runtimeDeps and get the executable from the package
          require.yamb = yambConfig // {
            cli = if builtins.isString yambConfig.cli then yambConfig.cli else lib.getExe yambConfig.cli;
          };
          runtimeDeps = if builtins.isString yambConfig.cli then [ ] else [ yambConfig.cli ];
        };
      }
    ];
}
