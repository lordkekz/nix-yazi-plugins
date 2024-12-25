{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkOption;
  inherit (lib.types) lines;
  cfg = config.programs.yazi.yaziPlugins;
in
{
  options.programs.yazi.yaziPlugins = {
    enable = mkEnableOption "yaziPlugins";
    runtimeDeps = mkOption {
      type = lib.types.listOf (lib.types.either lib.types.package lib.types.str);
      description = ''
        Additional runtime packages to add
        gets set by some modules
        to deactivate overlaying set this to
        lib.mkForce []
      '';
      default = [ ];
    };
  };
  config = lib.mkIf (cfg.runtimeDeps != [ ]) {
    programs.yazi.package = pkgs.yazi.override {
      extraPackages = config.programs.yazi.yaziPlugins.runtimeDeps;
    };
  };
}
