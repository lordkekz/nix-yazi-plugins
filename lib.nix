{ lib, ... }:
let
  inherit (lib) mkOption isList;
  inherit (lib.types)
    submodule
    str
    either
    listOf
    ;
in
{
  setKeys = keys: {
    programs.yazi.keymap.manager.prepend_keymap = lib.mapAttrsToList (_: key: {
      inherit (key) on run desc;
    }) keys;
  };
  mkRuntimeDeps =
    { pkgs }:
    mkOption {
      type = lib.types.listOf (lib.types.either lib.types.package lib.types.str);
      description = ''
        Additional runtime packages to add
        to deactivate overlaying `lib.mkForce []` the parent option
      '';
      default = pkgs;
    };
  mkDisableOption =
    description:
    mkOption {
      default = true;
      type = lib.types.bool;
      inherit description;
    };
  mkKeyOption =
    {
      on,
      run,
      desc,
    }:
    mkOption {
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
      default = {
        inherit on run desc;
      };
      apply =
        old:
        if isList old then
          {
            on = old;
            run = run;
          }
        else
          old;
    };

}
