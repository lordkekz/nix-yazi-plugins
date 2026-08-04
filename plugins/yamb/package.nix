{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "yaziPlugins-yamb";
  version = "0-unstable-2026-07-18";

  src = fetchFromGitHub {
    owner = "h-hg";
    repo = "yamb.yazi";
    rev = "5576bd790e6868019d3ce7e958873cee3c94d783";
    hash = "sha256-oq9zyVduKbOPuJVzFHiNIxe/JvNcqujS5edEjZJstpQ=";
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
