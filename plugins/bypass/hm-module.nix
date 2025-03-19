{
  options =
    { cfg, mkKeyOption, ... }:
    { lib, ... }:
    {
      keys = {
        left = mkKeyOption {
          on = [ "l" ];
          run = "plugin bypass smart_enter";
          desc = "Open a file, or recursively enter child directory, skipping children with only a single subdirectory";
        };
        right = mkKeyOption {
          on = [ "h" ];
          run = "plugin bypass reverse";
          desc = "Recursively enter parent directory, skipping parents with only a single subdirectory";
        };
      };
    };
  config = { cfg, setKeys, ... }: { config, lib, ... }: { } // (setKeys cfg.keys);
}
