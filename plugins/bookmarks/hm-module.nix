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
  };
  config = {
    cfg,
    setKeys,
    ...
  }: {
    config,
    lib,
    ...
  }:
    {} // (setKeys cfg.keys);
}
