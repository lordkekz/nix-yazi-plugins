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
        open = mkKeyOption {
          on = [
            "R"
            "b"
          ];
          run = "plugin recycle-bin";
          desc = "Open Recycle Bin menu";
        };
      };
      trash_dir = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = "Custom trash directory path (e.g., \"~/.local/share/Trash/\"). If null, uses system default.";
      };
    };
  config =
    {
      cfg,
      setKeys,
      ...
    }:
    { lib, pkgs, ... }:
    lib.mkMerge [
      (setKeys cfg.keys)
      {
        programs.yazi.yaziPlugins.require.recycle-bin = lib.optionalAttrs (cfg.trash_dir != null) {
          inherit (cfg) trash_dir;
        };
        programs.yazi.yaziPlugins.runtimeDeps = [ pkgs.trash-cli ];
      }
    ];
}
