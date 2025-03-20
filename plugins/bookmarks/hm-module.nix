{
  options =
    {
      cfg,
      mkKeyOption,
      ...
    }:
    { lib, ... }:
    {
      keys = {
        mark = mkKeyOption {
          on = [ "m" ];
          run = "plugin bookmarks save";
          desc = "Save current position as a bookmark";
        };
        jump = mkKeyOption {
          on = [ "'" ];
          run = "plugin bookmarks jump";
          desc = "Jump to a bookmark";
        };
        delete = mkKeyOption {
          on = [
            "b"
            "d"
          ];
          run = "plugin bookmarks delete";
          desc = "Delete a bookmark";
        };
        delete_all = mkKeyOption {
          on = [
            "b"
            "D"
          ];
          run = "plugin bookmarks delete_all";
          desc = "Delete all bookmarks";
        };
      };
      last_directory = {
        enable = lib.mkEnableOption "When enabled, a new bookmark is automatically created in ' which allows the user to jump back to the last directory.";
        persist = lib.mkEnableOption "When enabled the bookmarks will persist, i.e. if you close and reopen Yazi they will still be present.";
      };
      persist = lib.mkOption {
        type =
          with lib.types;
          nullOr (enum [
            "none"
            "all"
            "vim"
          ]);
        default = "none";
        description = "When enabled the bookmarks will persist, i.e. if you close and reopen Yazi they will still be present.";
      };
      desc_format = lib.mkOption {
        type =
          with lib.types;
          nullOr (enum [
            "full"
            "parent"
          ]);
        default = "full";
        description = "The format for the bookmark description.";
      };
      file_pick_mode = lib.mkOption {
        type =
          with lib.types;
          nullOr (enum [
            "hover"
            "parent"
          ]);
        default = "hover";
        description = "The mode for choosing which directory to bookmark.";
      };
      notify = {
        enable = lib.mkEnableOption "When enabled, notifications will be shown when the user creates a new bookmark and deletes one or all saved bookmarks.";
        timeout = lib.mkOption {
          type = with lib.types; int;
          default = 1;
          description = "The time a notification is displayed (in seconds)";
        };
        message = {
          new = lib.mkOption {
            type = with lib.types; str;
            default = "New bookmark '<key>' -> '<folder>'";
            description = "The notification message when creating a new bookmark";
          };
          delete = lib.mkOption {
            type = with lib.types; str;
            default = "Deleted bookmark in '<key>'";
            description = "The notification message when deleting a bookmark";
          };
          delete_all = lib.mkOption {
            type = with lib.types; str;
            default = "Deleted all bookmarks";
            description = "The notification message when deleting all bookmarks";
          };
        };
      };
    };
  config =
    {
      cfg,
      setKeys,
      ...
    }:
    { lib, ... }:
    lib.mkMerge [
      (setKeys cfg.keys)
      {
        programs.yazi.yaziPlugins.require.bookmarks = {
          inherit (cfg)
            persist
            desc_format
            file_pick_mode
            last_directory
            notify
            ;
        };
      }
    ];
}
