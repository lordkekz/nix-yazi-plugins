{
  options =
    { mkKeyOption, mkDisableOption, ... }:
    { lib, pkgs, ... }:
    {
      keys.compress = mkKeyOption {
        on = [ "C" ];
        run = "plugin ouch";
        desc = "Compress with ouch";
      };

      previewers = {
        enable = mkDisableOption "Whether to enable previewing archives with ouch";
        mimes = lib.mkOption {
          type = with lib.types; listOf str;
          description = "The list of mimes to preview with ouch";
          example = [
            "application/*zip"
            "application/x-tar"
            "application/x-bzip2"
            "application/xz"
          ];
          default = [
            "application/*zip"
            "application/x-tar"
            "application/x-bzip2"
            "application/x-7z-compressed"
            "application/x-rar"
            "application/vnd.rar"
            "application/x-xz"
            "application/xz"
            "application/x-zstd"
            "application/zstd"
            "application/java-archive"
          ];
        };
      };

      command = lib.mkOption {
        type = with lib.types; either package str;
        description = "The command for ouch to use to extract archives: either a string containing the command to be executed, or package containing an executable. If this option is a package, the package will be included as a runtime dependency for ouch and the executable in the package will be used as the command, otherwise the default package will be added instead.";
        example = "ouch";
        default = pkgs.ouch;
      };
    };
  config =
    { cfg, setKeys, ... }:
    { lib, pkgs, ... }:
    lib.mkMerge [
      (setKeys cfg.keys)
      {
        programs.yazi = {
          yaziPlugins.runtimeDeps = if builtins.isString cfg.command then [ pkgs.ouch ] else [ cfg.command ];
          settings.plugin = {
            prepend_previewers = lib.mkIf cfg.previewers.enable (
              builtins.map (mime: {
                inherit mime;
                run = "ouch";
              }) cfg.previewers.mimes
            );
            opener.extract =
              let
                extractCommand = if builtins.isString cfg.command then cfg.command else lib.getExe cfg.command;
              in
              [
                {
                  run = ''${extractCommand} -d -y "$@"'';
                  desc = "Extract here with ouch";
                }
              ];
          };
        };
      }
    ];
}
