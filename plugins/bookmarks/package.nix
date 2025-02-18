{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "yaziPlugins-bookmarks";
  version = "unstable-2025-02-18";

  src = fetchFromGitHub {
    owner = "dedukun";
    repo = "bookmarks.yazi";
    rev = "420a384f51da9bc018530068679d2e826f9ce14b";
    hash = "sha256-SBZQhdannSGQjU/m+xbuIrCxgM0mBZXGBVYSdYy9aR0=";
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
