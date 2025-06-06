{ lib, ... }:
let
  inherit (lib)
    mkOption
    isList
    showOption
    setAttrByPath
    filterAttrs
    mapAttrsToList
    ;
  inherit (lib.types)
    submodule
    str
    either
    listOf
    package
    ;
in
{
  setKeys = keys: {
    programs.yazi.keymap.manager.prepend_keymap =
      mapAttrsToList
        (_: key: {
          inherit (key) on run desc;
        })
        # `key` may be null due to mkMovedOption.
        # `key.on` may be empty if the keybind shouldn't be used.
        (filterAttrs (_: key: key != null && key.on != [ ]) keys);
  };
  mkRuntimeDeps =
    { pkgs }:
    mkOption {
      type = listOf package;
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
  # Based on nixpkgs's lib.mkRemovedOptionModule but adapted to work in our
  # non-standard way of setting options (works without using module imports)
  mkMovedOption =
    baseOptionPath: oldName: newName:
    setAttrByPath oldName (mkOption {
      visible = false;
      default = null;
      apply =
        x:
        lib.throwIf (x != null) "The option `${
          showOption (baseOptionPath ++ oldName)
        }' has been renamed to '${showOption (baseOptionPath ++ newName)}'" null;
    });
}
