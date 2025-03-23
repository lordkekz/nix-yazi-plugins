{
  options =
    { mkKeyOption, ... }:
    _: {
      keys = {
        toggle = mkKeyOption {
          on = [ "l" ];
          run = "plugin smart-enter";
          desc = "Enter the child directory, or open the file";
        };
      };
    };
  config = { cfg, setKeys, ... }: _: (setKeys cfg.keys);
}
