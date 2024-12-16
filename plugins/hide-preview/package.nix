{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "yaziPlugins-hide-preview";
  version = "unstable-2024-12-14";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "62f078905b4de55f19e328452c8a1f889ff2f6f4";
    sha256 = "sha256-PSVzjC1sdaIOtK5ave4kn3Ck8YwpjO3N9uV/WE6Skdo=";
  };

  buildPhase = ''
    mkdir $out
    cp $src/hide-preview.yazi/* $out
  '';

  meta = with lib; {
    description = "Switch the preview pane between hidden and shown.";
    homepage = "https://github.com/yazi-rs/plugins/tree/main/hide-preview.yazi";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
