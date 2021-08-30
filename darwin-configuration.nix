{ pkgs, config, ... }:
let
  machine = import ./system/machines;
in
{
  imports =
    [ <home-manager/nix-darwin> ./system/zsh ./system/fonts ] ++ (
      if (machine.work) then [ ./work/system-work.nix ] else []
    );

  nix = {
    # Auto upgrade nix package and the daemon service.
    # better not XD
    #  services.nix-daemon.enable = true;
    package = pkgs.nix;

    # https://github.com/LnL7/nix-darwin/issues/145
    # https://github.com/LnL7/nix-darwin/issues/105#issuecomment-567742942
    # fixed according to https://github.com/LnL7/nix-darwin/blob/b3e96fdf6623dffa666f8de8f442cc1d89c93f60/CHANGELOG
    nixPath = pkgs.lib.mkForce [
      {
        darwin-config = builtins.concatStringsSep ":" [
          "$HOME/.nixpkgs/darwin-configuration.nix"
          "$HOME/.nix-defexpr/channels"
        ];
      }
    ];
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (import ./overlays/jvm.nix)
      (import ./overlays/coursier.nix)
      (import ./overlays/vscode.nix)
    ];
  };

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users."${machine.username}" = {
      imports = [ ./home.nix ];
    };
  };

  networking.hostName = machine.hostname;

  system.defaults = {
    LaunchServices = { LSQuarantine = false; };
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark"; # Dark mode
      ApplePressAndHoldEnabled = false; # No accents
      KeyRepeat = 2; # I am speed
      InitialKeyRepeat = 15;
      AppleKeyboardUIMode = 3; # full control
      NSAutomaticQuoteSubstitutionEnabled = false; # No smart quotes
      NSAutomaticDashSubstitutionEnabled = false; # No em dash
      NSNavPanelExpandedStateForSaveMode =
        true; # Default to expanded "save" windows
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

  system.activationScripts.postActivation.text = ''
    echo "Clearing ~/Applications for Home Manager..." >&2
    rm -r ~/Applications
  '';
}
