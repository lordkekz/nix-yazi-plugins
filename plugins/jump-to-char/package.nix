{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "yaziPlugins-jump-to-char";
  version = "unstable-2025-03-08";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "2bf70d880e02db95394de360668325b46f804791";
    sha256 = "sha256-0A5UVbrP9+GRvX14VQm4Yxw+P9Ca5gtlk9qkLCVf5+Q=";
  };

  buildPhase = ''
    mkdir $out
    cp $src/jump-to-char.yazi/* $out
  '';

  meta = with lib; {
    description = "Vim-like f<char>, jump to the next file whose name starts with <char>.";
    homepage = "https://github.com/yazi-rs/plugins/tree/main/jump-to-char.yazi";
    license = licenses.mit;
    maintainers = [];
    platforms = platforms.all;
  };
}
