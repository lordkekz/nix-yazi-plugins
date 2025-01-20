{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkPackageOption mkOption;
  inherit (lib.types) lines;
  cfg = config.programs.yazi.yaziPlugins;
in
{
  options.programs.yazi.yaziPlugins = {
    enable = mkEnableOption "yaziPlugins";
    yaziBasePackage = mkPackageOption pkgs "yazi" { };
    runtimeDeps = mkOption {
      type = lib.types.listOf (lib.types.either lib.types.package lib.types.str);
      description = ''
        Additional runtime packages to make available for yazi and plugins.
        To deactivate overlaying set this to `lib.mkForce []`.

        This gets set by some plugin modules.
      '';
      default = [ ];
    };
  };
  config = lib.mkIf (cfg.runtimeDeps != [ ]) {
    programs.yazi.package = cfg.yaziBasePackage.override (
      # This is for the yazi wrapper from nixpkgs
      if (lib.functionArgs cfg.yaziBasePackage.override) ? extraPackages then
        { extraPackages = cfg.runtimeDeps; }
      # This is for the yazi wrapper from its flake
      else
        { runtimeDeps = ps: ps ++ cfg.runtimeDeps; }
    );
  };
}
