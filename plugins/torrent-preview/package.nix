{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "yaziPlugins-torrent-preview";
  version = "unstable-2025-06-21";

  src = fetchFromGitHub {
    owner = "kirasok";
    repo = "torrent-preview.yazi";
    rev = "f46528243c458de3ffce38c44607d5a0cde67559";
    hash = "sha256-VhJvNRKHxVla4v2JJeSnP0MOMBFSm4k7gfqjrHOMVlo=";
  };

  buildPhase = ''
    mkdir $out
    cp $src/* $out
  '';

  meta = with lib; {
    description = "A Yazi plugin for previewing BitTorrent files";
    homepage = "https://github.com/kirasok/torrent-preview.yazi";
    license = licenses.agpl3Only;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
