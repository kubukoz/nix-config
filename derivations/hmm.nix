{ rustPlatform }:

rustPlatform.buildRustPackage {
  name = "hmm";
  buildInputs = [];
  cargoSha256 = "14x31hl14iw7mw0jp652kam4jgbh4036ph88mqgdqyhh4vf07n2z";

  src = builtins.fetchGit {
    url = "git@github.com:kubukoz/hmm";
    ref = "v0.1.0";
    rev = "3c0f7485c19cd03711032f3afb2ab5d43c5b86e8";
  };

}
