{ coursier-tools, installShellFiles, lib }:

let
  version = "1.7.1";
  pname = "spotify-next";
  completions = builtins.fetchurl {
    url = lib.warn "TODO: use actual version in URL"
      "https://raw.githubusercontent.com/kubukoz/spotify-next/v1.7.2/completions.zsh";
    sha256 = "0ip60xbq8byik7hjq7lv4w5fk8aawwdw43gxjmwy51n52qdsa23a";
  };
in
coursier-tools.coursierBootstrap {
  inherit version pname;
  artifact = "com.kubukoz:spotify-next_3:${version}";
  buildInputs = [ installShellFiles ];
  postInstall = ''
    installShellCompletion --name _${pname} --zsh ${completions}
  '';
}
