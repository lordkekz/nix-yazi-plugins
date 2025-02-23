{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "yaziPlugins-glow";
  version = "unstable-2025-02-18";

  src = fetchFromGitHub {
    owner = "Reledia";
    repo = "glow.yazi";
    rev = "c76bf4fb612079480d305fe6fe570bddfe4f99d3";
    hash = "sha256-DPud1Mfagl2z490f5L69ZPnZmVCa0ROXtFeDbEegBBU=";
  };

  buildPhase = ''
    mkdir $out
    cp $src/* $out
  '';

  meta = with lib; {
    description = "Plugin for Yazi to preview markdown files with glow";
    homepage = "https://github.com/Reledia/glow.yazi";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
