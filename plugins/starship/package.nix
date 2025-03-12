{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "yaziPlugins-starship";
  version = "unstable-2025-02-18";

  src = fetchFromGitHub {
    owner = "Rolv-Apneseth";
    repo = "starship.yazi";
    rev = "f6939fbdbc3fdfcdc2a80251841e429e0cd5cf3c";
    sha256 = "sha256-5QQsFozbulgLY/Gl6QuKSOTtygULveoRD49V00e0WOw=";
  };

  buildPhase = ''
    mkdir $out
    cp $src/* $out
  '';

  meta = with lib; {
    description = "Starship prompt plugin for yazi";
    homepage = "https://github.com/Rolv-Apneseth/starship.yazi";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
