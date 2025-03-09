{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "yaziPlugins-max-preview";
  version = "unstable-2025-02-18";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "beb586aed0d41e6fdec5bba7816337fdad905a33";
    sha256 = "sha256-enIt79UvQnKJalBtzSEdUkjNHjNJuKUWC4L6QFb3Ou4=";
  };

  buildPhase = ''
    mkdir $out
    cp $src/max-preview.yazi/* $out
  '';

  meta = with lib; {
    description = "Maximize or restore the preview pane.";
    homepage = "https://github.com/yazi-rs/plugins/tree/main/max-preview.yazi";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
