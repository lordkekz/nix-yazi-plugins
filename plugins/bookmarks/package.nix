{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "yaziPlugins-bookmarks";
  version = "unstable-2025-01-21";

  src = fetchFromGitHub {
    owner = "dedukun";
    repo = "bookmarks.yazi";
    rev = "202e450b0088d3dde3c4a680f30cf9684acea1cc";
    hash = "sha256-cPvNEanJpcVd+9Xaenu8aDAVk62CqAWbOq/jApwfBVE=";
  };

  buildPhase = ''
    mkdir $out
    cp $src/* $out
  '';

  meta = with lib; {
    description = "A Yazi plugin that adds the basic functionality of vi-like marks.";
    homepage = "https://github.com/dedukun/bookmarks.yazi";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
