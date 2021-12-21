self: super:
let
  jre = if super.stdenv.isAarch64 then super.openjdk11 else super.graalvm11-ce;
  jdk = jre;
in
{
  inherit jre jdk;
}
