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
    ./app-links
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
      signal-desktop
      sl
      slack
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
    ] ++ map (path: callPackage path {}) [
      ./derivations/pidof.nix
      ./derivations/coconut.nix
      ./derivations/cpuinfo.nix
      ./derivations/discord.nix
    ];
  };
}
