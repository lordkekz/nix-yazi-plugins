{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "yaziPlugins-system-clipboard";
  version = "unstable-2024-11-23";

  src = fetchFromGitHub {
    owner = "orhnk";
    repo = "system-clipboard.yazi";
    rev = "7775a80e8d3391e0b3da19ba143196960a4efc48";
    hash = "sha256-tfR9XHvRqm7yPbTu/joBDpu908oceaUoBiIImehMobk=";
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
