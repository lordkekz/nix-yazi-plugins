{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "yaziPlugins-exifaudio";
  version = "unstable-2024-11-23";

  src = fetchFromGitHub {
    owner = "haennes";
    repo = "exifaudio.yazi";
    rev = "6bc168bfe664c75cb943089f72b1b8cdf61b9e0b";
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
