self: super: {
  mkCoursierPackage = import ../coursier {
    inherit (super) stdenv coursier;
  };
}
