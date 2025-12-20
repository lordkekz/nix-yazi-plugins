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

        jump_by_key = mkKeyOption {
          on = [
            "["
          ];
          run = "plugin whoosh jump_by_key";
          desc = "Jump bookmark by key";
        };
        # Basic bookmark operations
        save = mkKeyOption {
          on = [
            "]"
            "a"
          ];
          run = "plugin whoosh save";
          desc = "Add bookmark (hovered file/directory)";
        };

        save_cwd = mkKeyOption {
          on = [
            "]"
            "A"
          ];
          run = "plugin whoosh save_cwd";
          desc = "Add bookmark (current directory)";
        };

        # Temporary bookmarks
        save_temp = mkKeyOption {
          on = [
            "]"
            "t"
          ];
          run = "plugin whoosh save_temp";
          desc = "Add temporary bookmark (hovered file/directory)";
        };

        save_cwd_temp = mkKeyOption {
          on = [
            "]"
            "T"
          ];
          run = "plugin whoosh save_cwd_temp";
          desc = "Add temporary bookmark (current directory)";
        };

        # Jump to bookmarks
        jump_key_k = mkKeyOption {
          on = [ "<A-k>" ];
          run = "plugin whoosh jump_key_k";
          desc = "Jump directly to bookmark with key k";
        };

        jump_by_fzf = mkKeyOption {
          on = [
            "]"
            "f"
          ];
          run = "plugin whoosh jump_by_fzf";
          desc = "Jump bookmark by fzf";
        };

        # Delete bookmarks
        delete_by_key = mkKeyOption {
          on = [
            "]"
            "d"
          ];
          run = "plugin whoosh delete_by_key";
          desc = "Delete bookmark by key";
        };

        delete_by_fzf = mkKeyOption {
          on = [
            "]"
            "D"
          ];
          run = "plugin whoosh delete_by_fzf";
          desc = "Delete bookmarks by fzf (use TAB to select multiple)";
        };

        delete_all = mkKeyOption {
          on = [
            "]"
            "C"
          ];
          run = "plugin whoosh delete_all";
          desc = "Delete all user bookmarks";
        };

        # Rename bookmarks
        reaname_by_key = mkKeyOption {
          on = [
            "]"
            "r"
          ];
          run = "plugin whoosh rename_by_key";
          desc = "Rename bookmark by key";
        };

        rename_by_fzf = mkKeyOption {
          on = [
            "]"
            "R"
          ];
          run = "plugin whoosh rename_by_fzf";
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
                type = with lib.types; either (listOf (strMatching "^.$")) (strMatching "^.$"); # single char
                description = "A shortcut to jump to the bookmarks quickly";
              };
            };
          });
        description = "Declarative bookmarks for whoosh.yazi";
        example = [
          {
            tag = "Desktop";
            path = "$HOME/Deskop";
            key = "d";
          }
        ];
        default = [ ];
      };
      fzf_package = lib.mkOption {
        type = with lib.types; package;
        description = "the fzf package to use";
        default = pkgs.fzf;
      };
      jump_notify = lib.mkOption {
        type = with lib.types; bool;
        description = "Recieve notification everytime you jump.";
        default = true;
      };
      keys = lib.mkOption {
        type = with lib.types; separatedString "";
        description = "A string used for randomly generating keys, where the preceding characters have higher priority";
        default = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
      };
      special_keys = {
        create_temp = lib.mkOption {
          type = with lib.types; nullOr str;
          description = ''
            Create a temporary bookmark from the menu
            null maps to false
          '';
          default = "<Enter>";
        };
        fuzzy_search = lib.mkOption {
          type = with lib.types; nullOr str;
          description = ''
            Launch fuzzy search (fzf)
            null maps to false
          '';
          default = "<Space>";
        };
        history = lib.mkOption {
          type = with lib.types; nullOr str;
          description = ''
            Open directory history
            null maps to false
          '';
          default = "<Tab>";
        };
        previous_dir = lib.mkOption {
          type = with lib.types; nullOr str;
          description = ''
            Jump back to the previous directory
            null maps to false
          '';
          default = "<Tab>";
          apply = v: if isNull v then false else v;
        };
      };
      bookmarks_path = lib.mkOption {
        type = with lib.types; nullOr str;
        description = "The path of bookmarks";
        default = "${config.home.homeDirectory}/.config/yazi/bookmark";
      };
      home_alias_enabled =
        (lib.mkEnableOption "Wether to replace the home directory with ~ when displayed")
        // {
          default = true;
        };
      path_truncate_enabled = lib.mkEnableOption "Enable path truncation in navigation menu";
      path_max_depth = lib.mkOption {
        type = with lib.types; int;
        description = "Max path depth before truncation";
        default = 3;
      };
      fzf_path_truncate_enabled = lib.mkEnableOption "Enable path truncation in navigation menu in fzf";
      fzf_path_max_depth = lib.mkOption {
        type = with lib.types; int;
        description = "Max path depth before truncation in fzf";
        default = 3;
      };
      path_truncate_long_names_enabled = lib.mkEnableOption "Enable in navigation Menu";
      fzf_path_truncate_long_names_enabled = lib.mkEnableOption "Enable in fzf";
      path_max_folder_name_length = lib.mkOption {
        type = with lib.types; int;
        description = "Max Length in navigation Menu";
        default = 20;
      };
      fzf_path_max_folder_name_length = lib.mkOption {
        type = with lib.types; int;
        description = "Max Length in fzf";
        default = 20;
      };
      history_size = lib.mkOption {
        type = with lib.types; int;
        description = "Number of directories in history (default 10)";
        default = 10;
      };
      history_fzf_path_truncate_enabled = lib.mkEnableOption "Enable/disable path truncation by depth for history";
      history_fzf_path_max_depth = lib.mkOption {
        type = with lib.types; int;
        default = 5;
        description = "Maximum path depth before truncation for history (default 5)";

      };
      history_fzf_path_truncate_long_names_enabled = lib.mkEnableOption "Enable/disable long folder name truncation for history";

      history_fzf_path_max_folder_name_length = lib.mkOption {
        type = with lib.types; int;
        default = 30;
        description = "Maximum length for folder names in history (default 30)";
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
      whooshConfig = lib.attrsets.filterAttrs (name: val: val != null && name != "hotkeys") cfg;
    in
    lib.mkMerge [
      (setKeys cfg.hotkeys)
      {
        programs.yazi.yaziPlugins = {
          require.whoosh = whooshConfig;
          runtimeDeps = [ whooshConfig.fzf_package ];
        };
      }
    ];
}
