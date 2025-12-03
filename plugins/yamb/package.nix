{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "yaziPlugins-yamb";
  version = "unstable-2025-02-28";

  src = fetchFromGitHub {
    owner = "haennes";
    repo = "yamb.yazi";
    rev = "741c05ac3967e25bf40c1942df979454c31fb2df";
    hash = "sha256-3Cp3+v0laSVsDdTyG26EOh2xt18ER8P9Nla9vtRuj9k=";
  };

  buildPhase = ''
    mkdir $out
    cp $src/* $out
  '';

  meta = with lib; {
    description = "A Yazi plugin for bookmark management.";
    homepage = "https://github.com/dedukun/bookmarks.yazi";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
