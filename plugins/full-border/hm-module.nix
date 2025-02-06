{
  config = _: _: {
    programs.yazi.yaziPlugins.requiredPlugins = [
      {
        name = "full-border";
      }
    ];
  };
}
