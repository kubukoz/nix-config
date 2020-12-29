{ pkgs, lib, ... }:

{
  programs = {
    bat = {
      enable = true;
      config.theme = "ansi-dark";
    };
    broot.enable = true;
    fzf.enable = true;
    gh.enable = true;
    htop.enable = true;
    jq.enable = true;
    neovim.enable = true;
    aria2.enable = true;
  };

  imports = [
    ./programs/ssh.nix
    ./programs/git.nix
    ./programs/ngrok.nix
    ./zsh
    ./scala
    ./node
    ./secrets-module.nix
    ./vscode
  ];

  home = {
    sessionVariables = {
      LANG = "en_US.UTF-8";
      EDITOR = "nvim";
    };

    packages = with pkgs; [
      asciinema
      cachix
      ctop
      dhall
      dhall-json
      dhall-lsp-server
      ffmpeg
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
      (callPackage ./derivations/pidof.nix { })
    ];
  };

  secrets = import ./secrets.nix;
}
