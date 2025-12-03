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
    rev = "888026c6d5988bd9dc5be51f7f96787bb8cadc4b";
    hash = "sha256-8YtYYxNDfQBTyMxn6Q7/BCiTiscpiZFXRuX0riMlRWQ=";
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
