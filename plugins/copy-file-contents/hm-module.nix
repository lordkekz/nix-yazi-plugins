{
  options =
    {
      mkKeyOption,
      mkDisableOption,
      ...
    }:
    { lib, ... }:
    {
      keys = {
        mod = mkKeyOption {
          on = [
            "c"
            "C"
          ];
          run = "plugin copy-file-contents";
          desc = "Copy contents of file";
        };
      };
      append_char = lib.mkOption {
        type = lib.types.str;
        default = "\n";
        description = "Append character at the end of each file content";
      };
      notification = mkDisableOption "Set to false to disable notification after copying the contents";
    };
  config =
    { cfg, setKeys, ... }:
    { lib, ... }:
    lib.mkMerge [
      (setKeys cfg.keys)
      {
        programs.yazi.yaziPlugins.require."copy-file-contents" = {
          inherit (cfg) append_char notification;
        };
      }
    ];
}
