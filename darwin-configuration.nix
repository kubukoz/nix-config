{ config, pkgs, ... }:
let
  nodePackages = pkgs.callPackage ./node { };
  scalaPackages = pkgs.callPackage ./scala { };
in {
  nixpkgs.overlays = let
    graalvm = self: super: rec {
      jre = pkgs.callPackage ./graalvm { };
      jdk = jre;
    };
  in [ graalvm ];

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
    pkgs.nodePackages.node2nix
  ] ++ nodePackages ++ scalaPackages;

  nixpkgs.config.allowUnfree = true;

  # Auto upgrade nix package and the daemon service.
  #  services.nix-daemon.enable = true;
  # better not XD
  #  nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  nix.nixPath = pkgs.lib.mkForce [
    "darwin-config=/Users/kubukoz/.nixpkgs/darwin-configuration.nix:/Users/kubukoz/.nix-defexpr/channels"
  ];

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
