{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "yaziPlugins-bypass";
  version = "unstable-2025-02-18";

  src = fetchFromGitHub {
    owner = "Rolv-Apneseth";
    repo = "bypass.yazi";
    rev = "ecb1f7f6fd305ff4ffff548fa955595af6b26e60";
    sha256 = "sha256-XXp4XflrVrs8FrUCRUbSxWZTSGPrIGrpqvB1pARerKQ=";
  };

  buildPhase = ''
    mkdir $out
    cp $src/* $out
  '';

  meta = with lib; {
    description = "Yazi plugin for skipping directories with only a single sub-directory";
    homepage = "https://github.com/Rolv-Apneseth/bypass.yazi";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
