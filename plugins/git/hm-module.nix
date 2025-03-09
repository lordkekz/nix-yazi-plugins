{
  config = _: _: {
    programs.yazi = {
      initLua = ''
        require("git"):setup()
      '';

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
