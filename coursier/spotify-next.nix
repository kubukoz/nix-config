{ mkCoursierPackage }:

let
  version = "1.3.2";
in
mkCoursierPackage {
  name = "spotify-next";
  inherit version;
  artifact = "com.kubukoz:spotify-next_2.13:${version}";
}
