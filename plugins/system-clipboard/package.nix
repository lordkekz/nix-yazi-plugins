{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "yaziPlugins-system-clipboard";
  version = "0-unstable-2026-02-03";

  src = fetchFromGitHub {
    owner = "orhnk";
    repo = "system-clipboard.yazi";
    rev = "75a53300bed1946c6d488d42efc34864ea26ca85";
    hash = "sha256-djvSPRHjP9bc4eXTiHwty4byVgVFRBDvfNYlX/nHVaw=";
  };

  buildPhase = ''
    mkdir $out
    cp $src/* $out
  '';

  meta = with lib; {
    description = "Cross platform implementation of a simple system clipboard for yazi file manager";
    homepage = "https://github.com/orhnk/system-clipboard.yazi";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
