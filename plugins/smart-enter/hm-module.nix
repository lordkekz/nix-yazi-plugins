{
  options =
    { mkKeyOption, ... }:
    { lib, ... }:
    {
      keys = {
        toggle = mkKeyOption {
          on = [ "l" ];
          run = "plugin smart-enter";
          desc = "Enter the child directory, or open the file";
        };
      };

      open_multi = lib.mkEnableOption "Allow opening multiple files";
    };

  config =
    { cfg, setKeys, ... }:
    { lib, ... }:
    lib.mkMerge [
      (setKeys cfg.keys)
      {
        programs.yazi.yaziPlugins.require."smart-enter" = {
          inherit (cfg) open_multi;
        };
      }
    ];
}
