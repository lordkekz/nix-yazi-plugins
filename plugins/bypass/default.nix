{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "yaziPlugins-bypass";
  version = "2024-04-25";

  src = fetchFromGitHub {
    owner = "Rolv-Apneseth";
    repo = "bypass.yazi";
    rev = "c436638b91e3dcdc6961242a1a0608f76bddfcea";
    hash = "sha256-jxUR2dqNHUKdjdgLa7WQiqhdA0/Q2jt2sHxLNFcfC8w=";
  };

  buildPhase = ''
    mkdir $out
    cp $src/* $out
  '';

  meta = with lib; {
    description = "Yazi plugin for skipping directories with only a single sub-directory";
    homepage = "https://github.com/Rolv-Apneseth/bypass.yazi";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
