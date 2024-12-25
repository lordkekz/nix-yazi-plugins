{
  options =
    { mkKeyOption, ... }:
    _: {
      keys = {
        toggle = mkKeyOption {
          on = [ "T" ];
          run = "plugin hide-preview";
          desc = "Hide or show preview";
        };
      };
    };
  config = { cfg, setKeys, ... }: _: (setKeys cfg.keys);
}
