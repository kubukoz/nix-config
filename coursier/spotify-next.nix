{ coursier-tools }:

let
  version = "1.4.0";
in
coursier-tools.coursierBootstrap {
  name = "spotify-next";
  inherit version;
  artifact = "com.kubukoz:spotify-next_3:${version}";
}
