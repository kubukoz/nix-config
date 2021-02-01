self: super:

let
  key = "_1password";
  base = super."${key}";
  mainBinaryName = "op";
  mainBinary = "${base}/bin/${mainBinaryName}";

  printToken = "${self.bash}/bin/bash ${toString ./secret-1password.sh}";

  wrapper = self.writeScriptBin mainBinaryName
    ''OP_SESSION_my=$(${printToken}) ${mainBinary} "$@"'';

  completions = self.runCommand "${mainBinaryName}-zsh-completions" {
    nativeBuildInputs = [ self.installShellFiles ];
  } ''
    ${mainBinary} completion zsh > op-zsh
    installShellCompletion --name _op --zsh ./op-zsh
  '';

in {
  "${key}" = self.symlinkJoin {
    name = "op-wrapper";
    paths = [ wrapper base completions ];
  };
}
