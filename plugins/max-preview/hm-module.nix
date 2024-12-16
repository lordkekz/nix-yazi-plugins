{
  options = { mkKeyOption, ... }:
    _: {
      keys = {
        toggle = mkKeyOption {
          on = [ "R" ];
          run = "plugin max-preview";
          desc = "Maximize or restore preview";
        };
      };
    };
  config = { cfg, setKeys, ... }: _: (setKeys cfg.keys);
}
