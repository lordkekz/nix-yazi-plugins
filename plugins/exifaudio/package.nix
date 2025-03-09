{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "yaziPlugins-exifaudio";
  version = "unstable-2025-02-18";

  src = fetchFromGitHub {
    owner = "Sonico98";
    repo = "exifaudio.yazi";
    rev = "4379fcfa2dbe0b81fde2dd67b9ac2e0e48331419";
    hash = "sha256-CIimJU4KaKyaKBuiBvcRJUJqTG8pkGyytT6bPf/x8j8=";
  };
  buildPhase = ''
    mkdir $out
    cp $src/* $out
  '';

  meta = with lib; {
    description = "Preview audio files metadata on yazi ";
    homepage = "Preview audio files metadata on yazi ";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
