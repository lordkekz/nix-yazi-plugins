{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "relative-motions-yazi";
  version = "unstable-2024-05-02";

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
    description = "";
    homepage = "https://github.com/dedukun/relative-motions.yazi.git";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "relative-motions-yazi";
    platforms = platforms.all;
  };
}
