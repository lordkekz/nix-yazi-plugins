{
  options =
    { mkKeyOption, ... }:
    _: {
      keys = {
        toggle = mkKeyOption {
          on = [ "R" ];
          run = "plugin toggle-pane max-preview";
          desc = "Maximize or restore preview";
        };
      };
    };
  config = { cfg, setKeys, ... }: _: (setKeys cfg.keys);
}
