{ pkgs, lib, config, ... }:

{
  programs = {
    bat = {
      enable = true;
      config.theme = "ansi";
    };
    broot.enable = true;
    fzf.enable = true;
    htop.enable = true;
    jq.enable = true;
    aria2.enable = true;
    gpg.enable = true;
  };

  imports = [
    ./programs/ssh.nix
    ./programs/git.nix
    ./programs/neovim.nix
    ./programs/gh
    ./programs/zsh
    ./programs/ngrok
    ./scala
    ./node
    ./vscode
    ./semisecret.nix
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
      gti
      graphviz
      gnuplot
      httpie
      imgcat
      lame
      niv
      rnix-lsp
      nixpkgs-fmt
      pirate-get
      plantuml
      postgresql
      pstree
      python2
      redis
      sl
      speedtest-cli
      texlive.combined.scheme-basic
      tig
      tldr
      tokei
      tree
      websocat
      wget
      unrar
      youtube-dl
      bottom
      rustc
      cargo
    ] ++ map (path: callPackage path {}) [
      ./derivations/pidof.nix
    ];
  };
}
