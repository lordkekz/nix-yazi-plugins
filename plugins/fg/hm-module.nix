{
  options =
    { mkKeyOption, ... }:
    { lib, ... }:
    {
      enableRuntimeDependencies = lib.mkOption {
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
    {
      cfg,
      setKeys,
      pkgs,
      ...
    }:
    { lib, ... }:
    lib.mkMerge [
      (setKeys cfg.keys)
      {
        # Note: If dependencies are missing here, the plugin might still work
        # if the dependencies are available on your regular PATH.
        programs.yazi.yaziPlugins.runtimeDeps = lib.mkIf cfg.enableRuntimeDependencies (
          with pkgs;
          [
            bat
            fzf
            ripgrep-all
          ]
        );
      }
    ];
}
