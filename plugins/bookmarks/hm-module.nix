{
  options = {
    cfg,
    mkKeyOption,
    ...
  }: {lib, ...}: {
    keys = {
      mark = mkKeyOption {
        on = ["m"];
        run = "plugin bookmarks --args=save";
        desc = "Save current position as a bookmark";
      };
      jump = mkKeyOption {
        on = ["'"];
        run = "plugin bookmarks --args=jump";
        desc = "Jump to a bookmark";
      };
      delete = mkKeyOption {
        on = ["b" "d"];
        run = "plugin bookmarks --args=delete";
        desc = "Delete a bookmark";
      };
      delete_all = mkKeyOption {
        on = ["b" "D"];
        run = "plugin bookmarks --args=delete_all";
        desc = "Delete all bookmarks";
      };
    };
    persist = lib.mkOption {
      type = with lib.types;
        nullOr (enum [
          "none"
          "all"
          "vim"
        ]);
      default = "none";
      description = "When enabled the bookmarks will persist, i.e. if you close and reopen Yazi they will still be present.";
    };
    desc_format = lib.mkOption {
      type = with lib.types;
        nullOr (enum [
          "full"
          "parent"
        ]);
      default = "full";
      description = "The format for the bookmark description.";
    };
    file_pick_mode = lib.mkOption {
      type = with lib.types;
        nullOr (enum [
          "hover"
          "parent"
        ]);
      default = "hover";
      description = "The mode for choosing which directory to bookmark.";
    };
  };
  config = {
    cfg,
    setKeys,
    ...
  }: {lib, ...}:
    lib.mkMerge [
      (setKeys cfg.keys)
      {
        programs.yazi.initLua = let
          settings = {
            inherit (cfg) persist desc_format file_pick_mode;
          };
          settingsStr = lib.generators.toLua {} settings;
        in ''
          require("bookmarks"):setup(${settingsStr})
        '';
      }
    ];
}
