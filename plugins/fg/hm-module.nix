{
  options =
    { mkKeyOption, ... }:
    _: {
      enableRuntimeDependencies = mkOption {
        default = true;
        example = false;
        description = ''
          Whether to add the required runtime packages
          to `programs.yazi.yaziPlugins.runtimeDeps`.

          They are currently: bat fzf ripgrep-all
        '';
        type = lib.types.bool;
      };
      keys = {
        findByName = mkKeyOption {
          on = [
            "f"
            "f"
          ];
          run = "plugin fg --args='fzf'";
          desc = "find file by filename";
        };
        findByContentFuzzy = mkKeyOption {
          on = [
            "f"
            "g"
          ];
          run = "plugin fg";
          desc = "find file by content (fuzzy match)";
        };
        findByContentExact = mkKeyOption {
          on = [
            "f"
            "G"
          ];
          run = "plugin fg --args='rg'";
          desc = "find file by content (exact match)";
        };
      };
    };
  config =
    { cfg, setKeys, ... }:
    { lib, ... }:
    lib.mkMerge [
      (setKeys cfg.keys)
      {
        config = lib.mkIf cfg.enableRuntimeDependencies {
          programs.yazi.yaziPlugins.runtimeDeps = with pkgs; [
            bat
            fzf
            ripgrep-all
          ];
        };
      }
    ];
}
