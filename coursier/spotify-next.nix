{ coursier-tools }:

let
  version = "1.6.2";
in
coursier-tools.coursierBootstrap {
  name = "spotify-next";
  inherit version;
  artifact = "com.kubukoz:spotify-next_3:${version}";
}
