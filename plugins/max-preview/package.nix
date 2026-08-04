{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "yaziPlugins-max-preview";
  version = "0-unstable-2026-08-03";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "b9598e6cbe721aa29bf64836ce314584cfeb58fc";
    sha256 = "sha256-mrQq3r1dzM3DmEyke8CvSLbacgLQ4tNiqYHCOyXaqp0=";
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
