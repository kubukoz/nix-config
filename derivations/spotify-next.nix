{ coursier-tools, installShellFiles, lib }:

let
  version = "1.9.2";
  pname = "spotify-next";
  completions = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/kubukoz/spotify-next/v${version}/completions.zsh";
    sha256 = "1ffzfh9m65i5cs7c8v953dn0xampk952f362px146n1p86sgxr4k";
  };
in
coursier-tools.coursierBootstrap {
  inherit version pname;
  artifact = "com.kubukoz:spotify-next_3:${version}";
  buildInputs = [ installShellFiles ];
  postInstall = ''
    installShellCompletion --name _${pname} --zsh ${completions}
  '';
  mainClass = "com.kubukoz.next.Main";
  sha256 = "sha256-IRq1WjL61DLMkvzDCG+CIbkJU3rOiu9nSvHEhjT3tGg";
}
