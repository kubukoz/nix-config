{ config, pkgs, ... }: {
  environment.systemPackages = [
    pkgs.exa
    pkgs.aria2
    pkgs.asciinema
    pkgs.bat
    pkgs.broot
    pkgs.cachix
    pkgs.ctop
    pkgs.dhall
    pkgs.dhall-json
    pkgs.dhall-lsp-server
    pkgs.ffmpeg
    pkgs.fzf
    pkgs.ghc
    pkgs.git
    pkgs.github-cli
    pkgs.gnuplot
    pkgs.htop
    pkgs.httpie
    pkgs.imgcat
    pkgs.jekyll
    pkgs.jq
    pkgs.lame
    pkgs.neovim
    pkgs.niv
    pkgs.nixfmt
    pkgs.pirate-get
    pkgs.plantuml
    pkgs.postgresql
    pkgs.pstree
    pkgs.python2
    pkgs.redis
    pkgs.sl
    pkgs.speedtest-cli
    pkgs.tig
    pkgs.tldr
    pkgs.tokei
    pkgs.unrar
    pkgs.websocat
    pkgs.wget
    pkgs.youtube-dl
    pkgs.tree
    pkgs.ytop # in the future this will be pkgs.bottom
    pkgs.zsh
  ];

  environment.variables = { LANG = "en_US.UTF-8"; };

  nixpkgs.config.allowUnfree = true;

  # Auto upgrade nix package and the daemon service.
  #  services.nix-daemon.enable = true;
  # better not XD
  #  nix.package = pkgs.nix;

  environment.shellAliases = {
    lsd = "exa --long --header --git --all";
    dps = "docker-compose ps";
    dcp = "docker-compose";
    nss = "nix-shell";
    nb = "nix-build";
  };

  imports = [ ./zsh ./scala ./node ];

  # https://github.com/LnL7/nix-darwin/issues/145
  # https://github.com/LnL7/nix-darwin/issues/105#issuecomment-567742942
  # fixed according to https://github.com/LnL7/nix-darwin/blob/b3e96fdf6623dffa666f8de8f442cc1d89c93f60/CHANGELOG
  nix.nixPath = pkgs.lib.mkForce [{
    darwin-config = builtins.concatStringsSep ":" [
      "$HOME/.nixpkgs/darwin-configuration.nix"
      "$HOME/.nix-defexpr/channels"
    ];
  }];

  networking.hostName = "kubukoz-pro";

  system.stateVersion = 4;
}
