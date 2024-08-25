{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "yaziPlugins-hide-preview";
  version = "2024-07-15";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "c8b3e3979d79c110888d0bc2cab423f3d8093592";
    sha256 = "sha256-x45hP/A6XtWloAjam71fC6wPgrv8kNTr/KDlJFGMz8Q=";
  };

  buildPhase = ''
    mkdir $out
    cp $src/hide-preview.yazi/* $out
  '';

  meta = with lib; {
    description = "Switch the preview pane between hidden and shown.";
    homepage = "https://github.com/yazi-rs/plugins/tree/main/hide-preview.yazi";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
