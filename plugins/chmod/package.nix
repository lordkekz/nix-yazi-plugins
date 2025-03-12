{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "yaziPlugins-chmod";
  version = "unstable-2025-03-08";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "2bf70d880e02db95394de360668325b46f804791";
    sha256 = "sha256-0A5UVbrP9+GRvX14VQm4Yxw+P9Ca5gtlk9qkLCVf5+Q=";
  };

  buildPhase = ''
    mkdir $out
    cp $src/chmod.yazi/* $out
  '';

  meta = with lib; {
    description = "Execute chmod on the selected files to change their mode.";
    homepage = "https://github.com/yazi-rs/plugins/tree/main/chmod.yazi";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
