{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "yaziPlugins-relative-motions";
  version = "unstable-2025-02-18";

  src = fetchFromGitHub {
    owner = "dedukun";
    repo = "relative-motions.yazi";
    rev = "0d9c8cfae8d1f74227808150a0666bcbb1114d0e";
    sha256 = "sha256-wWOrPwQiJP1F/gqXPGrvKnNc1SSac4/9cDPdHjOgkOw=";
  };

  buildPhase = ''
    mkdir $out
    cp $src/* $out
  '';

  meta = with lib; {
    description = "This plugin adds the some basic vim motions like 3k, 12j, 10gg, etc.";
    homepage = "https://github.com/dedukun/relative-motions.yazi.git";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
