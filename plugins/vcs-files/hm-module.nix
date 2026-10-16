{
  options =
    { mkKeyOption, mkRuntimeDeps, ... }:
    { pkgs, ... }:
    {
      key = mkKeyOption {
        on = [
          "g"
          "c"
        ];
        run = "plugin vcs-files";
        desc = "Show Git file changes";
      };
      runtimeDeps = mkRuntimeDeps { pkgs = [ pkgs.git ]; };
    };
  config = { cfg, setKeys, ... }: _: (setKeys { inherit (cfg) key; });
}
