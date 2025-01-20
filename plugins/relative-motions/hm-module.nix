{
  options =
    { cfg, mkKeyOption, ... }:
    { lib, ... }:
    let
      inherit (lib) map listToAttrs;
      inherit (builtins) toString;
    in
    {
      keys = listToAttrs (
        lib.genList (
          idx_n:
          let
            idx = builtins.toString (idx_n + 1);
          in
          {
            name = idx;
            value = mkKeyOption {
              on = [ idx ];
              run = "plugin relative-motions --args=${idx}";
              desc = "Move in relative steps";
            };
          }
        ) 9
      );
    };
  config =
    { cfg, setKeys, ... }:
    _:
    {

      programs.yazi.initLua = ''
        require("starship"):setup()
      '';
    }
    // (setKeys cfg.keys);
}
