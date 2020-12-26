{ symlinkJoin, makeWrapper, mvn-search }:
symlinkJoin rec {
  name = "sbt-search";
  paths = [ mvn-search ];
  buildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/mvn-search \
      --add-flags "-f sbt"
  '';
}
