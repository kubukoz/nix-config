{ rustPlatform, installShellFiles, openssl, stdenv, darwin }:

rustPlatform.buildRustPackage {
  name = "hmm";
  buildInputs = let
    libs = if (stdenv.isDarwin) then [ darwin.apple_sdk.frameworks.Security ] else [];
  in
    [ installShellFiles openssl ] ++ libs;
  cargoSha256 = "19khl2ssdrih10m6m2ip795h299zwkms513xdais10b6cdwrmn66";

  src = builtins.fetchGit {
    url = "git@github.com:kubukoz/hmm";
    ref = "v0.5.1";
    rev = "72e37f5196204104043c05bd98f13b32a99ac64c";
  };

  postInstall = ''
    installShellCompletion --name _hmm completions/zsh/_hmm
  '';

}
