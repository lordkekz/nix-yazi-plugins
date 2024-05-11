{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "yaziPlugins-starship";
  version = "2024-04-03";

  src = fetchFromGitHub {
    owner = "Rolv-Apneseth";
    repo = "starship.yazi";
    rev = "6197e4cca4caed0121654079151632f6abcdcae9";
    hash = "sha256-oHoBq7BESjGeKsaBnDt0TXV78ggGCdYndLpcwwQ8Zts=";
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
