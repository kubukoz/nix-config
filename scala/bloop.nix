{ pkgs, ... }: {
  home.packages = [ pkgs.bloop ];

  programs.sbt = {
    plugins = [{
      org = "ch.epfl.scala";
      artifact = "sbt-bloop";
      version = "1.4.6";
    }];
  };

  home.file.".bloop/bloop.json".text =
    builtins.toJSON { javaOptions = [ "-Xmx2G" ]; };
}
