{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "yaziPlugins-max-preview";
  version = "2024-07-15";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "c8b3e3979d79c110888d0bc2cab423f3d8093592";
    hash = "sha256-x45hP/A6XtWloAjam71fC6wPgrv8kNTr/KDlJFGMz8Q=";
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
