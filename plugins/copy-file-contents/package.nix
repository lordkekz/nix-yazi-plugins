{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "yaziPlugins-copy-file-contents";
  version = "unstable-2025-02-18";

  src = fetchFromGitHub {
    owner = "AnirudhG07";
    repo = "plugins-yazi";
    rev = "524c52c7e433834e36a502abd1e31a6a65c8caf0";
    hash = "sha256-GrPqcHYG+qHNi80U+EJJd1JjdAOexiE6sQxsqdeCSMg=";
  };

  buildPhase = ''
    mkdir $out
    cp $src/copy-file-contents.yazi/* $out
  '';

  meta = with lib; {
    description = "Copy the contents of a file to clipboard directly from Yazi.";
    homepage = "https://github.com/AnirudhG07/plugins-yazi/tree/main/copy-file-contents.yazi";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
