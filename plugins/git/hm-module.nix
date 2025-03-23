{
  config = _: _: {
    programs.yazi = {
      yaziPlugins.require.git = { };
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
