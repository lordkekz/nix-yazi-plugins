{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "yaziPlugins-open-with-cmd";
  version = "unstable-2025-02-18";

  src = fetchFromGitHub {
    owner = "haennes";
    repo = "open-with-cmd.yazi";
    rev = "4ef507a87fa93c8d3c5a5b8c54c015396fc886f7";
    hash = "sha256-vN7zQeGuYN8TPKlA/6+SNFTVsA607z1DJPKXlNFJ9YM=";
  };

  buildPhase = ''
    mkdir $out
    cp $src/* $out
  '';
  meta = with lib; {
    description = "This is a Yazi plugin for opening files with a prompted command.";
    homepage = "https://github.com/Ape/open-with-cmd.yazi";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
