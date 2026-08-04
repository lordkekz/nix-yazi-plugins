{
  config =
    { VAtLeast, ... }:
    { pkgs, ... }:
    {
      programs.yazi = {
        yaziPlugins = {
          require.git = { };
          runtimeDeps = [ pkgs.git ];
        };
        settings.plugin = {
          prepend_fetchers = [
            (
              {
                run = "git";
              }
              // (
                if VAtLeast "25.12.30" then
                  {
                    url = "*";
                  }
                else
                  {
                    name = "*";
                  }
              )
              // (
                if VAtLeast "26.5.7" then
                  {
                    id = "git";
                  }
                else
                  {
                    group = "git";
                  }
              )
            )
            (
              {
                run = "git";
              }
              // (
                if VAtLeast "25.12.30" then
                  {
                    url = "*/";
                  }
                else
                  {
                    name = "*/";
                  }
              )
              // (
                if VAtLeast "26.5.7" then
                  {
                    id = "git";
                  }
                else
                  {
                    group = "git";
                  }
              )
            )
          ];
        };
      };
    };
}
