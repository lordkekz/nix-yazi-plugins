{
  options =
    {
      cfg,
      mkKeyOption,
      mkMovedOption,
      recursiveUpdateList,
      ...
    }:
    { lib, ... }:
    recursiveUpdateList [
      {
        keys = {
          smart-enter = mkKeyOption {
            on = [ "l" ];
            run = "plugin bypass smart-enter";
            desc = "Open a file, or recursively enter child directory, skipping children with only a single subdirectory";
          };
          enter = mkKeyOption {
            on = [ ];
            run = "plugin bypass";
            desc = "Recursively enter child directory, skipping children with only a single subdirectory. Files are not opened.";
          };
          leave = mkKeyOption {
            on = [ "h" ];
            run = "plugin bypass reverse";
            desc = "Recursively enter parent directory, skipping parents with only a single subdirectory.";
          };
        };
      }
      (mkMovedOption [ "keys" ] [ "right" ] [ "leave" ])
      (mkMovedOption [ "keys" ] [ "left" ] [ "smart-enter" ])
    ];
  config = { cfg, setKeys, ... }: { config, lib, ... }: { } // (setKeys cfg.keys);
}
