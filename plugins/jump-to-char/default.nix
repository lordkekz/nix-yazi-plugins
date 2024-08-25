{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "yaziPlugins-jump-to-char";
  version = "unstable-2024-08-21";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "b6597919540731691158831bf1ff36ed38c1964e";
    sha256 = "07dm70s48mas4d38zhnrfw9p3sgk83ki70xi1jb2d191ya7a2p3j";
  };

  buildPhase = ''
    mkdir $out
    cp $src/jump-to-char.yazi/* $out
  '';

  meta = with lib; {
    description = "Vim-like f<char>, jump to the next file whose name starts with <char>.";
    homepage = "https://github.com/yazi-rs/plugins/tree/main/jump-to-char.yazi";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
