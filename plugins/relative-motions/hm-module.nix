{
  options =
    { cfg, mkKeyOption, ... }:
    { lib, ... }:
    {
      keys = lib.listToAttrs (
        lib.genList (
          idx_n:
          let
            idx = builtins.toString (idx_n + 1);
          in
          {
            name = idx;
            value = mkKeyOption {
              on = [ idx ];
              run = "plugin relative-motions ${idx}";
              desc = "Move in relative steps";
            };
          }
        ) 9
      );
      show_numbers = lib.mkOption {
        type =
          with lib.types;
          nullOr (enum [
            "relative"
            "absolute"
            "relative_absolute"
          ]);
        default = null;
        description = "Shows relative or absolute numbers before the file icon";
      };
      show_motion = lib.mkEnableOption "Shows current motion in Status bar";
      only_motions = lib.mkEnableOption ''
        If true, only the motion movements will be enabled,
        i.e., the commands for delete, cut, yank and visual selection will be disabled'';
    };
  config =
    { cfg, setKeys, ... }:
    { lib, ... }:
    lib.mkMerge [
      (setKeys cfg.keys)
      {
        programs.yazi.yaziPlugins.require."relative-motions" = {
          inherit (cfg) show_numbers show_motion only_motions;
        };
      }
    ];
}
