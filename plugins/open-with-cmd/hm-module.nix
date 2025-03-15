{
  options =
    { mkKeyOption, ... }:
    _: {
      keys = {
        open_terminal = mkKeyOption {
          on = [ "o" ];
          run = "plugin open-with-cmd block";
          desc = "Open with command in the terminal";
        };
        open = mkKeyOption {
          on = [ "O" ];
          run = "plugin open-with-cmd";
          desc = "Open with command";
        };
      };
    };
  config =
    {
      cfg,
      setKeys,
      ...
    }:
    _: (setKeys cfg.keys);
}
