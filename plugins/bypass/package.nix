{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "yaziPlugins-bypass";
  version = "unstable-2024-12-14";

  src = fetchFromGitHub {
    owner = "haennes";
    repo = "bypass.yazi";
    rev = "d8a7b7f1b75f86d507f358ffe9155ca12f1f3a28";
    sha256 = "sha256-XvVz+8sLG2gJnUUQDFofu/EsGewSB4heVTz8P3CSwGk=";
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
