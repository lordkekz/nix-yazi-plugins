{
  options =
    { cfg, mkKeyOption, ... }:
    { lib, ... }:
    {
      keys = {
        mod = mkKeyOption {
          on = [
            "c"
            "m"
          ];
          run = "plugin chmod";
          desc = "Chmod on selected files";
        };
      };
    };
  config = { cfg, setKeys, ... }: { config, lib, ... }: { } // (setKeys cfg.keys);
}
