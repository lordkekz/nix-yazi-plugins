{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "yaziPlugins-fg";
  version = "2024-11-09";

  src = fetchFromGitHub {
    owner = "lpnh";
    repo = "fg.yazi";
    rev = "a7e1a828ef4dfb01ace5b03fe0691c909466a645";
    sha256 = "QxtWyp91XcW8+PSYtER47Pcc1Y9i3LplJyTzeC5Gp2s=";
  };

  buildPhase = ''
    mkdir $out
    cp $src/* $out
  '';

  meta = with lib; {
    description = "A Yazi plugin for searching by file content or by filenames using ripgrep or ripgrep-all with fzf preview.";
    homepage = "https://github.com/lpnh/fg.yazi";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
