{
  lib,
  stdenv,
  fetchFromGitLab,
}:
stdenv.mkDerivation {
  pname = "yaziPlugins-whoosh";
  version = "0-unstable-2026-05-16";

  src = fetchFromGitLab {
    owner = "WhoSowSee";
    repo = "whoosh.yazi";
    rev = "47100012460ae5292cb837fca5444fecfd78f4a5";
    hash = "sha256-BerfIDF8EHTnAELVSoaFAEoX+8gNIbkAFfeA38vStf0=";
  };

  buildPhase = ''
    mkdir $out
    cp -r $src/* $out
  '';

  meta = with lib; {
    description = "A Yazi plugin for bookmark management.";
    homepage = "https://gitlab.com/WhoSowSee/whoosh.yazi";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
