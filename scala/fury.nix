{ stdenv, gnutar, coursier, bloop, ipfs }:

# variables originating from https://gateway.pinata.cloud/ipfs/QmYQKTw8KeDcGVaGKeimC4Cf9cBdnHLe5qFP6y4rDev3WT
let
  version = "0.18.29";
  ipfsHash = "QmP8PFjpKsbAP3P9EGhkYqLEGrhxg7WfXu536cTjAFNm1b";
  ipfsGateway = "https://gateway.pinata.cloud/ipfs";
  remoteSrc = builtins.fetchurl {
    url = "${ipfsGateway}/${ipfsHash}";
    sha256 = "1iwsvwvlijx2i9ym1v3w14v77a99kv1ykj84h3hf0qlpl073pp73";
  };
in
stdenv.mkDerivation {
  name = "fury";
  buildInputs = [ gnutar coursier bloop ipfs ];

  src = remoteSrc;
  # src = "${./.}/fury-${version}.tar.gz";

  unpackPhase = ''
    echo $src
    ls $src
    tar -xzf $src
  '';

  installPhase = ''
    echo "java home is: $JAVA_HOME"

    cp -R . $out
  '';
}
