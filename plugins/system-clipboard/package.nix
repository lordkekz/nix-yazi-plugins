{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "yaziPlugins-system-clipboard";
  version = "unstable-2025-02-18";

  src = fetchFromGitHub {
    owner = "orhnk";
    repo = "system-clipboard.yazi";
    rev = "efb8f03e632adcdc6677fd5f471c74f4c71fdf9a";
    hash = "sha256-zOQQvbkXq71t2E4x45oM4MzVRlZ4hhe6RkvgcP8tdYE=";
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
