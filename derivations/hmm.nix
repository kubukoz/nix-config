{ rustPlatform, installShellFiles, openssl, stdenv, darwin }:

rustPlatform.buildRustPackage {
  name = "hmm";
  buildInputs = let
    libs = if (stdenv.isDarwin) then [ darwin.apple_sdk.frameworks.Security ] else [];
  in
    [ installShellFiles openssl ] ++ libs;
  cargoSha256 = "0x750k3djzis48d6b11wxn0gsg423zh2hcqdi528vsy8zriaxr72";

  src = builtins.fetchGit {
    url = "git@github.com:kubukoz/hmm";
    ref = "v0.5.0";
    rev = "fdc7b455697782453721f1648a591c6e6b5c265f";
  };

  postInstall = ''
    installShellCompletion --name _hmm completions/zsh/_hmm
  '';

}
