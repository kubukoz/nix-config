{ pkgs, ... }: {
  imports = [ <home-manager/nix-darwin> ./system/zsh ./system/fonts ];

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
          jre = self.callPackage ./graalvm { };
          jdk = jre;
        in {
          inherit jre jdk;
          # Override necessary because the scala package is configured (via callPackage)
          # to use jdk8 (at the time of writing, that's zulu).
          scala = super.scala.override { inherit jre; };
        };
      bloop = self: super: {
        bloop = self.callPackage ./derivations/bloop.nix {
          version = "1.4.6-15-209c2a5c";
        };
      };
    in [ graalvm bloop (import ./overlays/vscode.nix) ];
  };

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.kubukoz = ./home.nix;
  };

  networking.hostName = "kubukoz-pro";

  system.defaults = {
    LaunchServices = { LSQuarantine = false; };
    NSGlobalDomain = {
      ApplePressAndHoldEnabled = false;
      KeyRepeat = 2; # I am speed
      InitialKeyRepeat = 15;
      AppleKeyboardUIMode = 3; # full control
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true; # don't ask
    };
    dock = {
      autohide = true;
      show-recents = false;
      tilesize = 45;
    };
    finder = {
      AppleShowAllExtensions = true;
      _FXShowPosixPathInTitle = true;
    };
    trackpad.Clicking = true;
    loginwindow.GuestEnabled = false;
  };

  system.stateVersion = 4;
}
