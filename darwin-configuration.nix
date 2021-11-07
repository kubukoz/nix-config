{ pkgs, config, ... }:
let
  machine = import ./system/machines;
  home-manager = let sources = import ./nix/sources.nix; in sources.home-manager;
in
{
  imports =
    [ (home-manager + "/nix-darwin") ./system/zsh ./system/fonts ] ++ (
      if (machine.work) then [ ./work/system-work.nix ] else []
    );

  services.nix-daemon = {
    enable = true;
  };

  nix = {
    # package = (import (import ./nix/sources.nix).unstable {}).nix;
    package = pkgs.nix;
    trustedUsers = [ machine.username ];

    # todo
    useSandbox = false;
    # extraOptions = ''
    #   extra-experimental-features = nix-command flakes
    # '';
  };

  nixpkgs = {
    overlays = [
      (import ./overlays/unstable.nix)
      (import ./overlays/jvm.nix)
      (import ./overlays/coursier.nix)
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
