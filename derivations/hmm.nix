{ rustPlatform, installShellFiles, stdenv, darwin }:

rustPlatform.buildRustPackage {
  name = "hmm";
  buildInputs = let
    libs = if (stdenv.isDarwin) then [ darwin.apple_sdk.frameworks.Security ] else [];
  in
    [ installShellFiles ] ++ libs;
  cargoSha256 = "11n63qxncdlvy836z9p6nd2rwnbf2fh46rfj0inrl3385yfm2ni7";

  src = builtins.fetchGit {
    url = "git@github.com:kubukoz/hmm";
    ref = "v0.4.1";
    rev = "3cb0a6adc55c7df394aa69a7c08ec0415ae4a48e";
  };

  postInstall = ''
    installShellCompletion --name _hmm completions/zsh/_hmm
  '';

}
