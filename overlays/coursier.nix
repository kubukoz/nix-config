_: super: {
  coursier-tools = import ../coursier {
    inherit (super) stdenv coursier;
  };
}
