{ rustPlatform, installShellFiles }:

rustPlatform.buildRustPackage {
  name = "hmm";
  buildInputs = [ installShellFiles ];
  cargoSha256 = "0m6snji1k83v4kdbhpw6j8gx6kfqgxgr6p3vr968vr0lk7izkn1z";

  src = builtins.fetchGit {
    url = "git@github.com:kubukoz/hmm";
    ref = "v0.2.3";
    rev = "b6cba08e1f2695a84b1672a74c6bef321867dd42";
  };

  postInstall = ''
    installShellCompletion --name _hmm completions/zsh/_hmm
  '';

}
