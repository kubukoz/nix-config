{ config, pkgs, ... }:
let
  graalvm = import ./graalvm { inherit pkgs; };
  graalvm-overlay = self: super: {
    jdk = graalvm;
    jre = graalvm // { home = graalvm; };
  };
  bloop = import ./bloop { inherit pkgs; };
in {
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
    pkgs.ytop
    pkgs.zsh
    pkgs.jdk
    pkgs.sbt
    pkgs.scala
    pkgs.ammonite
    # pkgs.scalafmt
    pkgs.coursier
    bloop
  ];

  nixpkgs.overlays = [ graalvm-overlay ];
  nixpkgs.config.allowUnfree = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
