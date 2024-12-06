{ coursier-tools, installShellFiles, lib }:

let
  version = "1.11.1";
  pname = "spotify-next";
  completions = builtins.fetchurl {
    url =
      "https://raw.githubusercontent.com/kubukoz/spotify-next/v${version}/completions.zsh";
    sha256 = "sha256:0bni575srlacr8q4sxx7bxwrrjp6azhx28fji87hiiv0llc5a6jy";
  };
in coursier-tools.coursierBootstrap {
  inherit version pname;
  artifact = "com.kubukoz:spotify-next_3:${version}";
  buildInputs = [ installShellFiles ];
  postInstall = ''
    installShellCompletion --name _${pname} --zsh ${completions}
  '';
  mainClass = "com.kubukoz.next.Main";
  sha256 = "sha256-V3rNjuNVx6XQEQwprdizaDDVpwuH0l9SMy7HAUU88yA=";
}
