{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "yaziPlugins-full-border";
  version = "unstable-2024-08-21";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "b6597919540731691158831bf1ff36ed38c1964e";
    sha256 = "07dm70s48mas4d38zhnrfw9p3sgk83ki70xi1jb2d191ya7a2p3j";
  };

  buildPhase = ''
    mkdir $out
    cp $src/full-border.yazi/* $out
  '';

  meta = with lib; {
    description = "Add a full border to Yazi to make it look fancier.";
    homepage = "https://github.com/yazi-rs/plugins/tree/main/full-border.yazi";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
