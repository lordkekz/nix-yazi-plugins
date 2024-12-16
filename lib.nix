{ lib, ... }: {
  setKeys = keys: {
    programs.yazi.keymap.manager.prepend_keymap =
      lib.mapAttrsToList (_: key: { inherit (key) on run desc; }) keys;
  };
  mkKeyOption = { on, run, desc }:
    let
      inherit (lib) mkOption isList;
      inherit (lib.types) submodule str either listOf;
    in mkOption {
      description = desc;
      type = either (submodule {
        options = {
          on = mkOption {
            type = listOf str;
            default = on;
          };
          run = mkOption {
            type = str;
            default = run;
          };

          desc = mkOption {
            type = str;
            default = desc;
          };
        };
      }) (listOf str);
      default = { inherit on run desc; };
      apply = old:
        if isList old then {
          on = old;
          run = run;
        } else
          old;
    };

}
