{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "yaziPlugins-jump-to-char";
  version = "unstable-2024-12-14";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "62f078905b4de55f19e328452c8a1f889ff2f6f4";
    sha256 = "sha256-PSVzjC1sdaIOtK5ave4kn3Ck8YwpjO3N9uV/WE6Skdo=";
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
