{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "yaziPlugins-jump-to-char";
  version = "unstable-2025-02-18";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "beb586aed0d41e6fdec5bba7816337fdad905a33";
    sha256 = "sha256-enIt79UvQnKJalBtzSEdUkjNHjNJuKUWC4L6QFb3Ou4=";
  };

  buildPhase = ''
    mkdir $out
    cp $src/jump-to-char.yazi/* $out
  '';

  meta = with lib; {
    description = "Vim-like f<char>, jump to the next file whose name starts with <char>.";
    homepage = "https://github.com/yazi-rs/plugins/tree/main/jump-to-char.yazi";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
