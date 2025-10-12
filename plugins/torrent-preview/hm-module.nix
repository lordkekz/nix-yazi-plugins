{
  config =
    _:
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      programs.yazi = {
        settings.plugin.prepend_previewers = [
          {
            mime = "application/bittorrent";
            run = "torrent-preview";
          }
        ];

        yaziPlugins = {
          runtimeDeps = [ pkgs.transmission_4 ];
        };
      };
    };
}
