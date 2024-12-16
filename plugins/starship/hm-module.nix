{
  config = _: _: {
    programs.yazi.initLua = ''
      require("starship"):setup()
    '';
  };
}
