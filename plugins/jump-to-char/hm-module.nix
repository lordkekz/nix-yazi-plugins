{
  options = { mkKeyOption, ... }:
    _: {
      keys = {
        toggle = mkKeyOption {
          on = [ "f" ];
          run = "plugin jump-to-char";
          desc = "Jump to char";
        };
      };
    };
  config = { cfg, setKeys, ... }: _: (setKeys cfg.keys);
}
