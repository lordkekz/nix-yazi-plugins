{
  options = { mkKeyOption, ... }:
    _: {
      keys = {
        toggle = mkKeyOption {
          on = [ "F" ];
          run = "plugin smart-filter";
          desc = "Smart filter";
        };
      };
    };
  config = { cfg, setKeys, ... }: _: (setKeys cfg.keys);
}
