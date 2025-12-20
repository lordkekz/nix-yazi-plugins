{
  lib,
  stdenv,
  fetchFromGitLab,
}:
stdenv.mkDerivation {
  pname = "yaziPlugins-whoosh";
  version = "unstable-2025-10-25";

  src = fetchFromGitLab {
    owner = "WhoSowSee";
    repo = "whoosh.yazi";
    rev = "2a55ce41409603fa79cc9571406e69f5dc8f2257";
    hash = "sha256-GNAchresDa6A2UFM0yKKCzoixVczKrHvNrsBCZkpqjk=";
  };

  buildPhase = ''
    mkdir $out
    cp -r $src/* $out
  '';

  meta = with lib; {
    description = "A Yazi plugin for bookmark management.";
    homepage = "https://gitlab.com/WhoSowSee/whoosh.yazi";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
