{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "yaziPlugins-open-with-cmd";
  version = "unstable-2025-01-21";

  src = fetchFromGitHub {
    owner = "Ape";
    repo = "open-with-cmd.yazi";
    rev = "a80d1cf41fc23f84fbdf0b8b26c5b13f06455472";
    hash = "sha256-IAJSZhO6WEIjSXlUvmcX3rgpQKu358vfe5dEm7JtmPg=";
  };

  buildPhase = ''
    mkdir $out
    cp $src/* $out
  '';
  meta = with lib; {
    description = "This is a Yazi plugin for opening files with a prompted command.";
    homepage = "https://github.com/Ape/open-with-cmd.yazi";
    license = licenses.mit;
    maintainers = [];
    platforms = platforms.all;
  };
}
