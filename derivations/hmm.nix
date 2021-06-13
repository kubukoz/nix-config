{ rustPlatform, installShellFiles, tree }:

rustPlatform.buildRustPackage {
  name = "hmm";
  buildInputs = [ installShellFiles tree ];
  cargoSha256 = "0m6snji1k83v4kdbhpw6j8gx6kfqgxgr6p3vr968vr0lk7izkn1z";

  src = builtins.fetchGit {
    url = "git@github.com:kubukoz/hmm";
    ref = "v0.2.2";
    rev = "3e24cf64d91d0398e3eecf29249c5b551fbb7b33";
  };

  postInstall = ''
    installShellCompletion --name _hmm completions/zsh/_hmm
  '';

}
