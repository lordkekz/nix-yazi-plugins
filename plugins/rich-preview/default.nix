{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "yaziPlugins-rich-preview";
  version = "unstable-2024-11-23";

  src = fetchFromGitHub {
    owner = "AnirudhG07";
    repo = "rich-preview.yazi";
    rev = "fe432192db970b5c3f8a9f037280c7431d9c2abe";
    hash = "sha256-sKKdZJxPcbGy9lMhnwbklWEhUjYArVhQyoiH3kuMVzY=";
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
