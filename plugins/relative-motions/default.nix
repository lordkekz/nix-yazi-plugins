{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "yaziPlugins-relative-motions";
  version = "2024-05-02";

  src = fetchFromGitHub {
    owner = "dedukun";
    repo = "relative-motions.yazi";
    rev = "8b3ee6341a4a4d0dc264a96ad8a8f6cdff585e89";
    hash = "sha256-bGJuCJzUrTh6bre1ECvL3cXQBRolAUHxWMd4awaCCbA=";
  };

  buildPhase = ''
    mkdir $out
    cp $src/* $out
  '';

  meta = with lib; {
    description = "This plugin adds the some basic vim motions like 3k, 12j, 10gg, etc.";
    homepage = "https://github.com/dedukun/relative-motions.yazi.git";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
