self: super:
let
  key = "gh";
  mainBinaryName = "gh";
  printToken = ./secret-github-cli.sh;

  base = super."${key}";
  mainBinary = "${base}/bin/${mainBinaryName}";

  wrapper = self.writeScriptBin mainBinaryName ''
    GITHUB_TOKEN=$(${self.bash}/bin/bash ${
      toString printToken
    }) ${mainBinary} "$@"'';

in {
  "${key}" = self.symlinkJoin {
    name = "${key}-wrapper";
    paths = [ wrapper base ];
  };
}
