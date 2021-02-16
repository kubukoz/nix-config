{ pkgs, config, ... }:
# todo: get HM to actually do this link... get Spotlight to use it.
let
  machine = import ./system/machines;
  apps = pkgs.buildEnv {
    name = "home-manager-applications";
    paths = config.home.packages;
    pathsToLink = "/Applications";
  };
  path = "${apps}/Applications";
in
{
  home.file."Applications".source = path;
}
