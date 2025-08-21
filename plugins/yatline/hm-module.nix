{
  options =
    _:
    { lib, ... }:
    {
      # NOTE: yatline has a lot of configuration options
      extraSetup = lib.mkOption {
        type = with lib.types; attrs;
        description = "Extra configuration to pass to `setup`";
        example = {
          show_background = false;
          header_line = {
            left = {
              section_a = [
                {
                  type = "line";
                  custom = false;
                  name = "tabs";
                  params = [ "left" ];
                }
              ];
            };
          };
        };
        default = { };
      };
    };
  config =
    { cfg, ... }:
    { pkgs, ... }:
    {
      programs.yazi.yaziPlugins.require."yatline" = cfg.extraSetup;
    };
}
