{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "yaziPlugins-glow";
  version = "unstable-2024-11-21";

  src = fetchFromGitHub {
    owner = "loqusion";
    repo = "glow.yazi";
    rev = "39d621a5d1308103690fee04b9840b8395410fdf";
    hash = "sha256-1k2bOXHwsDxpgLVMOA2TW+WbJoIOb+3qj322oObHnAs=";
  };

  buildPhase = ''
    mkdir $out
    cp $src/* $out
  '';

  meta = with lib; {
    description = "Plugin for Yazi to preview markdown files with glow";
    homepage = "https://github.com/Reledia/glow.yazi";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
