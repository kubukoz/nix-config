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
    ref = "v0.4.0";
    rev = "9a9ed8f8b9227bb8c2751c19338d838d8ff5a82f";
  };

  postInstall = ''
    installShellCompletion --name _hmm completions/zsh/_hmm
  '';

}
