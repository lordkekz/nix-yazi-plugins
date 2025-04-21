{
  options =
    { cfg, mkKeyOption, ... }:
    { lib, ... }:
    {
      keys = {
        up = mkKeyOption {
          on = [ "<C-y>" ];
          run = "seek -5";
          desc = "go up in file";
        };
        down = mkKeyOption {
          on = [ "<C-e>" ];
          run = "seek 5";
          desc = "go down in file";
        };
      };
    };
  config =
    { cfg, setKeys, ... }:
    {
      config,
      lib,
      pkgs,
      ...
    }:
    lib.mkMerge [
      {
        programs.yazi = {
          settings.plugin.prepend_previewers = [
            {
              name = "*.md";
              run = "glow";
            }
          ];

          yaziPlugins = {
            runtimeDeps = [ pkgs.glow ];
          };
        };
      }
      (setKeys cfg.keys)
    ];
}
