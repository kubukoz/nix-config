# todo: remove user-specific path, get HM path another way, get HM to actually do this link... get Spotlight to use it.
let
  path =
    "/nix/var/nix/profiles/per-user/kubukoz/home-manager/home-path/Applications";
in
if (builtins.pathExists path) then {
  home.file."Applications".source = path;
} else {}
