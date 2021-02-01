self: super:

let
  key = "_1password";
  mainBinaryName = "op";
  printToken = ./secret-1password.sh;

  base = super."${key}";
  completionFileName = "_${mainBinaryName}";
  mainBinary = "${base}/bin/${mainBinaryName}";

  wrapper = self.writeScriptBin mainBinaryName ''
    OP_SESSION_my=$(${self.bash}/bin/bash ${
      toString printToken
    }) ${mainBinary} "$@"'';

  completions = self.runCommand "${mainBinaryName}-zsh-completions" {
    nativeBuildInputs = [ self.installShellFiles ];
  } ''
    ${mainBinary} completion zsh > ${mainBinaryName}-zsh
    installShellCompletion --name ${completionFileName} --zsh ./${mainBinaryName}-zsh
  '';

in {
  "${key}" = self.symlinkJoin {
    name = "${key}-wrapper";
    paths = [ wrapper base completions ];
  };
}
