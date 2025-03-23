{
  config =
    _:
    { pkgs, ... }:
    {
      programs.yazi = {
        yaziPlugins = {
          require.git = { };
          runtimeDeps = [ pkgs.git ];
        };
        settings.plugin = {
          prepend_fetchers = [
            {
              id = "git";
              name = "*";
              run = "git";
            }
            {
              id = "git";
              name = "*/";
              run = "git";
            }
          ];
        };
      };
    };
}
