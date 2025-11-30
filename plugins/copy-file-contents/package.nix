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
    rev = "71545f4ee1a0896c555b3118dc3d2b0a1b92fad9";
    hash = "sha256-JsQJg/SfXLQ/JIpl2YsfzdGpS1ZeWIACJwWTpHaVH3w=";
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
