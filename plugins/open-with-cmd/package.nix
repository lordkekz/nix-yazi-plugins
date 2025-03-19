{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "yaziPlugins-open-with-cmd";
  version = "unstable-2025-02-18";

  src = fetchFromGitHub {
    owner = "Ape";
    repo = "open-with-cmd.yazi";
    rev = "433cf301c36882c31032d3280ab0c94825fc5e9f";
    hash = "sha256-QazKfNEPFdkHwMrH4D+VMwj8fGXM8KHDdSvm1tik3dQ=";
  };

  buildPhase = ''
    mkdir $out
    cp $src/* $out
  '';
  meta = with lib; {
    description = "This is a Yazi plugin for opening files with a prompted command.";
    homepage = "https://github.com/Ape/open-with-cmd.yazi";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
