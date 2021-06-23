{ rustPlatform, installShellFiles }:

rustPlatform.buildRustPackage {
  name = "hmm";
  buildInputs = [ installShellFiles ];
  cargoSha256 = "077m3v3g4g2cb4vp3yrjaizfiixsny2cwkix6hdy6ih3qpm6wl2r";

  src = builtins.fetchGit {
    url = "git@github.com:kubukoz/hmm";
    ref = "v0.3.1";
    rev = "4bdba038572fd1ce6af506890e8045faff24ec61";
  };

  postInstall = ''
    installShellCompletion --name _hmm completions/zsh/_hmm
  '';

}
