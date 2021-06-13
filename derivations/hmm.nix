{ rustPlatform }:

rustPlatform.buildRustPackage {
  name = "hmm";
  buildInputs = [];
  cargoSha256 = "14x31hl14iw7mw0jp652kam4jgbh4036ph88mqgdqyhh4vf07n2z";

  src = builtins.fetchGit {
    url = "git@github.com:kubukoz/hmm";
    ref = "v0.2.0";
    rev = "9312d360309c3eb0be0a9059f5372b8b53ff54e7";
  };

}
