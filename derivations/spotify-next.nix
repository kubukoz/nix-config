{ coursier-tools, installShellFiles, lib }:

let
  version = "1.9.1";
  pname = "spotify-next";
  completions = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/kubukoz/spotify-next/v${version}/completions.zsh";
    sha256 = "sha256:1qgc58nd0fq1s5nkj3dp1rr34wi33s6mm811pw1qyqir2gbmqap3";
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
  sha256 = "sha256-0ndUoY/El7gz6XyCK1aawlwRM4xcupnRchLCn3Y3rQg=";
}
