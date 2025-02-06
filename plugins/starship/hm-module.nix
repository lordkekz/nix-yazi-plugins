{
  config = _: _: {
    programs.yazi.yaziPlugins.requiredPlugins = [
      {
        name = "starship";
      }
    ];
  };
}
