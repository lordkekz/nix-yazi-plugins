{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "yaziPlugins-smart-filter";
  version = "unstable-2025-02-18";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "beb586aed0d41e6fdec5bba7816337fdad905a33";
    sha256 = "sha256-enIt79UvQnKJalBtzSEdUkjNHjNJuKUWC4L6QFb3Ou4=";
  };

  buildPhase = ''
    mkdir $out
    cp $src/smart-filter.yazi/* $out
  '';

  meta = with lib; {
    description = "A Yazi plugin that makes filters smarter: continuous filtering, automatically enter unique directory, open file on submitting.";
    homepage = "https://github.com/yazi-rs/plugins/tree/main/smart-filter.yazi";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
