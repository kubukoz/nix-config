{ stdenv }:
let
  name = "meslo-nerd";
  version = "32c7d40239c93507277f14522be90b5750f442c9";
in
stdenv.mkDerivation {
  name = "${name}-${version}";
  src =
    let
      mkVariant = { variant, sha256 }:
        let
          baseUrl =
            "https://github.com/romkatv/powerlevel10k-media/raw/${version}";
          variantEscaped = spaceReplacement:
            builtins.replaceStrings [ " " ] [ spaceReplacement ] variant;

        in
        builtins.fetchurl {
          name = "MesloLGS-NF-${variantEscaped "-"}.ttf";
          url = "${baseUrl}/MesloLGS%20NF%20${variantEscaped "%20"}.ttf";
          inherit sha256;
        };

    in
    map mkVariant [
      {
        variant = "Regular";
        sha256 = "1jydmjlhssvmj0ddy7vzn0cp6wkdjk32lvxq64wrgap8q9xy14li";
      }
      {
        variant = "Bold";
        sha256 = "0w9byh20804qscsj13wj9v3llaqqzbkg5dmpwf0yqmxcvgs8dp7b";
      }
      {
        variant = "Italic";
        sha256 = "1442jp3zh92fz7fs5xn4853djnbchkqj7i09avnhpgp9bbn07fzz";
      }
      {
        variant = "Bold Italic";
        sha256 = "0g5q6my8k6aaf26sq610v9v17j3gsba63f1wv2yix48sdj3pxvbz";
      }
    ];
  dontUnpack = true;
  installPhase = ''
    mkdir -p $out/share/fonts/truetype/${name}
    cp $src $out/share/fonts/truetype/${name}
  '';
}
