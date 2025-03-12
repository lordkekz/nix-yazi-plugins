{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "yaziPlugins-rich-preview";
  version = "unstable-2025-02-18";

  src = fetchFromGitHub {
    owner = "AnirudhG07";
    repo = "rich-preview.yazi";
    rev = "2559e5fa7c1651dbe7c5615ef6f3b5291347d81a";
    hash = "sha256-dW2gAAv173MTcQdqMV32urzfrsEX6STR+oCJoRVGGpA=";
  };

  buildPhase = ''
    mkdir -p $out
    cp -r $src/* $out/
  '';

  meta = with lib; {
    description = "Rich preview plugin for yazi file manager";
    homepage = "https://github.com/AnirudhG07/rich-preview.yazi";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
