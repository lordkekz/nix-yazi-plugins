{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "yaziPlugins-copy-file-contents";
  version = "unstable-2024-11-20";

  src = fetchFromGitHub {
    owner = "AnirudhG07";
    repo = "plugins-yazi";
    rev = "f871a9c0b9322f9882ea7613015e68f618f4e15f";
    hash = "sha256-OSS+EWOoRumVdy2lN86jmi14tR+b0VsvfwVn5ka4GPg=";
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
