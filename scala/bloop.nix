{ pkgs, ... }: {
  home.packages = [ bloop ];

  programs.sbt = {
    plugins = [{
      org = "ch.epfl.scala";
      artifact = "sbt-bloop";
      version = "1.4.6";
    }];
  };
}
