self: super:
let
  printToken = "${self.bash}/bin/bash ${toString ./secret-github-cli.sh}";
  wrapper = self.writeScriptBin "gh"
    ''GITHUB_TOKEN=$(${printToken}) ${super.gh}/bin/gh "$@"'';
  gh = self.symlinkJoin {
    name = "gh-wrapper";
    paths = [ wrapper super.gh ];
  };

in { gh = gh; }
