{ lib, ... }:
let
  inherit (lib) mkEnableOption;
  inherit (lib.types) lines;
in {
  options.programs.yazi.yaziPlugins = {
    enable = mkEnableOption "yaziPlugins";
  };
}
