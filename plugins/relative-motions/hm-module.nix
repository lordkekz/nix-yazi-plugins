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
      show_numbers = lib.mkOption {
        type = lib.types.enum [
          "relative"
          "absolute"
          "relative_absolute"
          null
        ];
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
        programs.yazi.initLua =
          let
            show_numbers =
              if (cfg.show_numbers == null) then "" else ''show_numbers = "${cfg.show_numbers}", ''; # optinalString doesnt work here
          in
          ''
            require("relative-motions"):setup({${show_numbers}show_motion = ${lib.trivial.boolToString cfg.show_motion}, only_motions=${lib.trivial.boolToString cfg.only_motions} })
          '';
      }
    ];
}
