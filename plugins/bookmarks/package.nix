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
    rev = "fe0b1de939fa49068ac6b35da8d6680799931f1c";
    hash = "sha256-5ZW73yHKEfKmN/JsZUINUVyEwvK4bA4DlufRgdT1toI=";
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
