{ rustPlatform, installShellFiles }:

rustPlatform.buildRustPackage {
  name = "hmm";
  buildInputs = [ installShellFiles ];
  cargoSha256 = "077m3v3g4g2cb4vp3yrjaizfiixsny2cwkix6hdy6ih3qpm6wl2r";

  src = builtins.fetchGit {
    url = "git@github.com:kubukoz/hmm";
    ref = "v0.3.0";
    rev = "fa9b0f23004db25a87c06a9de7a1a0146283aff7";
  };

  postInstall = ''
    installShellCompletion --name _hmm completions/zsh/_hmm
  '';

}
