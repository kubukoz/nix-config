{ rustPlatform, installShellFiles, openssl, stdenv, darwin, cacert, src }:

rustPlatform.buildRustPackage {
  name = "hmm";
  buildInputs = let
    libs = if (stdenv.isDarwin) then [ darwin.apple_sdk.frameworks.Security ] else [];
  in
    [ installShellFiles openssl cacert ] ++ libs;

  cargoSha256 = "19khl2ssdrih10m6m2ip795h299zwkms513xdais10b6cdwrmn66";

  inherit src;

  postInstall = ''
    installShellCompletion --name _hmm completions/zsh/_hmm
  '';

}
