{ pkgs
, config
, machine
, home-manager
, unstable
, ...
}:
{
  imports =
    [ (home-manager.darwinModules.home-manager) ./system/zsh ./system/fonts ] ++ (
      if (machine.work) then [ ./work/system-work.nix ] else []
    );

  services.nix-daemon = {
    enable = true;
  };

  nix = {
    package = pkgs.unstable.nix_2_4;

    trustedUsers = [ machine.username ];

    # todo
    useSandbox = false;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs = {
    overlays = [
      (import ./overlays/unstable.nix { inherit unstable; })
      (import ./overlays/coursier.nix)
      (import ./overlays/jvm.nix)
      (import ./overlays/vscode.nix)
    ];
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "openssl-1.0.2u"
      ];
    };
  };

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users."${machine.username}" = {
      imports = [ ./home.nix ];
    };
    extraSpecialArgs = { inherit machine; };
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
