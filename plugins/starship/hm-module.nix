{
  options =
    { mkDisableOption, ... }:
    _: {
      enable_starship = mkDisableOption "wether to enable starship in home-manager";
    };
  config =
    { cfg, ... }:
    { lib, ... }:
    {
      programs.yazi.yaziPlugins.require.starship = { };
      programs.starship.enable = lib.mkIf cfg.enable_starship true;
    };
}
