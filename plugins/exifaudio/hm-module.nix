{
  options =
    _:
    { lib, pkgs, ... }:
    {
      package = lib.mkOption {
        type = lib.types.package;
        description = "The package to use for exifaudio";
        default = pkgs.exiftool;
      };

      mediainfo = {
        enable = lib.mkEnableOption "When enabled, mediainfo will be used alongside exiftool to provide more accurate metadata";
        package = lib.mkOption {
          type = lib.types.package;
          description = "The package to use for mediainfo";
          default = pkgs.mediainfo;
        };
      };
    };
  config =
    { cfg, ... }:
    { lib, pkgs, ... }:
    {
      programs.yazi = {
        settings.plugin.prepend_previewers = [
          {
            mime = "audio/*";
            run = "exifaudio";
          }
        ];
        # NOTE: even when mediainfo is used, exiftool is still needed to show covers
        yaziPlugins.runtimeDeps = [
          cfg.package
        ]
        ++ lib.optional (cfg.mediainfo.enable) cfg.mediainfo.package;
      };
    };
}
