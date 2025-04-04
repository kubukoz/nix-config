{ pkgs, config, machine, home-manager, ... }@inputs: {
  imports = [ (home-manager.darwinModules.home-manager) ];

  # This sets NIX_PATH, maybe don't remove
  programs.zsh.enable = true;

  nix = {
    enable = true;

    package = pkgs.nix;

    settings = {
      trusted-users = [ machine.username ];

      # todo
      sandbox = false;
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs = {
    overlays = [
      (final: prev: {
        jre = final.openjdk21;
        jdk = final.openjdk21;
      })
      (import ./overlays/coursier.nix)
      (import ./overlays/vscode.nix)
    ];
    config = { allowUnfree = true; };
  };

  users.users.${machine.username}.home = machine.homedir;

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users."${machine.username}" = { imports = [ ./home.nix ]; };
    extraSpecialArgs = { inherit machine; };
  };

  networking.hostName = machine.hostname;

  security.pam.services.sudo_local.touchIdAuth = true;

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
