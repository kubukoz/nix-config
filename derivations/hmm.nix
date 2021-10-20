{ rustPlatform, installShellFiles, openssl, stdenv, darwin, cacert }:

let
  sources = import ../nix/sources.nix;
in
rustPlatform.buildRustPackage {
  name = "hmm";
  buildInputs = let
    libs = if (stdenv.isDarwin) then [ darwin.apple_sdk.frameworks.Security ] else [];
  in
    [ installShellFiles openssl cacert ] ++ libs;
  cargoSha256 = "19khl2ssdrih10m6m2ip795h299zwkms513xdais10b6cdwrmn66";

  src = sources.hmm;

  postInstall = ''
    installShellCompletion --name _hmm completions/zsh/_hmm
  '';

}
