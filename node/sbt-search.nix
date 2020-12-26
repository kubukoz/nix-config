{ symlinkJoin, makeWrapper, mvn-search }:
symlinkJoin {
  name = "sbt-search";
  paths = [ mvn-search ];
  buildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/mvn-search \
      --add-flags "-f sbt"
  '';
}
