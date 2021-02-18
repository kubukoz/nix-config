{ pkgs, ... }:
let
  machine = import ../system/machines;
in
{
  home.packages = [ pkgs.bloop ];

  programs.sbt = {
    plugins = [
      {
        org = "ch.epfl.scala";
        artifact = "sbt-bloop";
        version = pkgs.bloop.version;
      }
    ];
  };

  home.file.".bloop/bloop.json".text =
    builtins.toJSON { javaOptions = [ "-Xmx${machine.bloop.memory.max-heap}" ]; };
}
