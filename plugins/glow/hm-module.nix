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
    {
      cfg,
      setKeys,
      VAtLeast,
      ...
    }:
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
            (
              {
                run = "glow";
              }
              // (
                if VAtLeast "25.12.29" then
                  {
                    url = "*.md";
                  }
                else
                  {
                    name = "*.md";

                  }
              )
            )
          ];

          yaziPlugins = {
            runtimeDeps = [ pkgs.glow ];
          };
        };
      }
      (setKeys cfg.keys)
    ];
}
