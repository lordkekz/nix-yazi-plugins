{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "yaziPlugins-open-with-cmd";
  version = "unstable-2025-02-18";

  src = fetchFromGitHub {
    owner = "haennes";
    repo = "open-with-cmd.yazi";
    rev = "bcaf8ddc6d89639ce68b2c4023d9c1a288c61a79";
    hash = "sha256-tBkdZ0thfYByTMK11Kkpr14QTTqhUt2rlr9Ej+nfLqc=";
  };

  buildPhase = ''
    mkdir $out
    cp $src/* $out
  '';
  meta = with lib; {
    description = "This is a Yazi plugin for opening files with a prompted command.";
    homepage = "https://github.com/Ape/open-with-cmd.yazi";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
