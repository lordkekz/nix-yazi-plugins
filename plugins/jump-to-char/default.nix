{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "yaziPlugins-jump-to-char";
  version = "2024-07-15";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "0dc9dcd5794ca7910043174ec2f2fe3561016983";
    sha256 = "sha256-8RanvdS62IqkkKfswZUKynj34ckS9XzC8GYI9wkd3Ag=";
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
