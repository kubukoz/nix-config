{ rustPlatform, installShellFiles }:

rustPlatform.buildRustPackage {
  name = "hmm";
  buildInputs = [ installShellFiles ];
  cargoSha256 = "14x31hl14iw7mw0jp652kam4jgbh4036ph88mqgdqyhh4vf07n2z";

  src = builtins.fetchGit {
    url = "git@github.com:kubukoz/hmm";
    ref = "v0.2.1";
    rev = "3e24cf64d91d0398e3eecf29249c5b551fbb7b33";
  };

  postInstall = ''
    installShellCompletion --name _hmm completions/zsh/_hmm
  '';

}
