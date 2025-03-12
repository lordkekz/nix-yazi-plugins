{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "yaziPlugins-hide-preview";
  version = "unstable-2025-03-08";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "2bf70d880e02db95394de360668325b46f804791";
    sha256 = "sha256-0A5UVbrP9+GRvX14VQm4Yxw+P9Ca5gtlk9qkLCVf5+Q=";
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
