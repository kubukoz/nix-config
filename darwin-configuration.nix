{ pkgs
, config
, machine
, home-manager
, ...
}@inputs:
{
  imports =
    [ (home-manager.darwinModules.home-manager) ./system/zsh ./system/fonts ];

  services.nix-daemon = {
    enable = true;
  };

  nix = {
    package = pkgs.nix;

    trustedUsers = [ machine.username ];

    # todo
    useSandbox = false;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs = {
    overlays = [
      (import ./overlays/coursier.nix)
      (import ./overlays/jvm.nix)
      (import ./overlays/vscode.nix)
      (_: prev: { nix-direnv = prev.nix-direnv.override { enableFlakes = true; }; })
    ];
    config = {
      allowUnfree = true;
    };
  };

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users."${machine.username}" = {
      imports = [ ./home.nix ];
    };
    extraSpecialArgs = {
      inherit machine;
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
}
