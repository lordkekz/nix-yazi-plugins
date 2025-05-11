{
  options =
    {
      config,
      mkKeyOption,
      ...
    }:
    { lib, ... }:
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
        type = with lib.types; listOf attrs;
        description = "Declarative bookmarks";
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
        type = with lib.types; str;
        description = "The cli for fzf";
        default = "fzf";
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
        # default = null;
      };
    };
  config =
    {
      cfg,
      setKeys,
      ...
    }:
    { lib, ... }:
    let
      yambConfig = lib.attrsets.filterAttrs (name: val: val != null || name != "hotkeys") cfg;
    in
    lib.mkMerge [
      (setKeys cfg.hotkeys)
      {
        programs.yazi.yaziPlugins.require.yamb = yambConfig;
        # {
        #   inherit (yambConfig)
        #     bookmarks
        #     jump_notify
        #     cli
        #     path
        #     keys
        #     ;
        #   # ${if path != null then path else null} = path;
        # };
      }
    ];
}
