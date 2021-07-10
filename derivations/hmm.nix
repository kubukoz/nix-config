{ rustPlatform, installShellFiles }:

rustPlatform.buildRustPackage {
  name = "hmm";
  buildInputs = [ installShellFiles ];
  cargoSha256 = "077m3v3g4g2cb4vp3yrjaizfiixsny2cwkix6hdy6ih3qpm6wl2r";

  src = builtins.fetchGit {
    url = "git@github.com:kubukoz/hmm";
    ref = "v0.4.0";
    rev = "11n63qxncdlvy836z9p6nd2rwnbf2fh46rfj0inrl3385yfm2ni7";
  };

  postInstall = ''
    installShellCompletion --name _hmm completions/zsh/_hmm
  '';

}
