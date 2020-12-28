{ pkgs, lib, ... }:

{
  programs = {
    bat.enable = true;
    broot.enable = true;
    fzf.enable = true;
    gh.enable = true;
    htop.enable = true;
    jq.enable = true;
    neovim.enable = true;
  };

  imports = [
    ./ssh.nix
    ./git.nix
    ./ngrok.nix
    ./zsh
    ./scala
    ./node
    ./secrets-module.nix
  ];

  home = {
    sessionVariables = {
      LANG = "en_US.UTF-8";
      EDITOR = "nvim";
    };

    packages = with pkgs; [
      aria2
      asciinema
      cachix
      ctop
      dhall
      dhall-json
      dhall-lsp-server
      ffmpeg
      ghc
      git-crypt
      gnuplot
      httpie
      imgcat
      jekyll
      lame
      niv
      nixfmt
      pirate-get
      plantuml
      postgresql
      pstree
      python2
      redis
      sl
      speedtest-cli
      tig
      tldr
      tokei
      tree
      unrar
      websocat
      wget
      youtube-dl
      ytop # in the future this will be 'bottom'
      (callPackage ./brew-exiles/pidof.nix { })
    ];
  };

  secrets = import ./secrets.nix;
}
