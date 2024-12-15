{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "yaziPlugins-full-border";
  version = "unstable-2024-12-14";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "62f078905b4de55f19e328452c8a1f889ff2f6f4";
    sha256 = "sha256-PSVzjC1sdaIOtK5ave4kn3Ck8YwpjO3N9uV/WE6Skdo=";
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
