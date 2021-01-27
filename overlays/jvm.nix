self: super:
let
  jre = self.callPackage ../derivations/graalvm { };
  jdk = jre;
in {
  inherit jre jdk;
  # Override necessary because the scala package is configured (via callPackage)
  # to use jdk8 (at the time of writing, that's zulu).
  scala = super.scala.override { inherit jre; };
  bloop = self.callPackage ../derivations/bloop.nix {
    version = "1.4.6-15-209c2a5c";
  };
}
