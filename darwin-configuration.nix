{ pkgs, ... }: {
  imports = [ <home-manager/nix-darwin> ./system/zsh ];

  nix = {
    # Auto upgrade nix package and the daemon service.
    # better not XD
    #  services.nix-daemon.enable = true;
    package = pkgs.nix;

    # https://github.com/LnL7/nix-darwin/issues/145
    # https://github.com/LnL7/nix-darwin/issues/105#issuecomment-567742942
    # fixed according to https://github.com/LnL7/nix-darwin/blob/b3e96fdf6623dffa666f8de8f442cc1d89c93f60/CHANGELOG
    nixPath = pkgs.lib.mkForce [{
      darwin-config = builtins.concatStringsSep ":" [
        "$HOME/.nixpkgs/darwin-configuration.nix"
        "$HOME/.nix-defexpr/channels"
      ];
    }];
  };

  nixpkgs = {
    config.allowUnfree = true;

    overlays = let
      graalvm = self: super:
        let
          jre = pkgs.callPackage ./graalvm { };
          jdk = jre;
        in { inherit jre jdk; };
    in [ graalvm ];
  };

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.kubukoz = import ./home.nix;
  };

  networking.hostName = "kubukoz-pro";

  system.stateVersion = 4;
}
