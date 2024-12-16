{
  config = _: _: {
    programs.yazi.initLua = ''
      require("full-border"):setup()
    '';
  };
}
