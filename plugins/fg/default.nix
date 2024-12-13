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
    sha256 = "024nmc0ldkf9xzi6ymnk45d3ij2wismwfcd4p9025p5rdfsy4ynj";
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
