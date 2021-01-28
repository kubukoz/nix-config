{ pkgs, lib, config, ... }:

{
  programs = {
    bat = {
      enable = true;
      config.theme = "ansi-dark";
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
    ./programs/ngrok.nix
    ./zsh
    ./scala
    ./node
    ./secrets-module.nix
    ./vscode
    ./neovim.nix
  ];

  home = {
    sessionVariables = {
      LANG = "en_US.UTF-8";
      EDITOR = "nvim";
      # for pitgull
      GIT_API_URL = "https://gitlab.com";
      GIT_API_TOKEN = config.secrets.gitlab-com.token;
    };

    packages = with pkgs; [
      asciinema
      cachix
      ctop
      dhall
      dhall-json
      dhall-lsp-server
      ffmpeg
      github-cli
      gnuplot
      httpie
      imgcat
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
      texlive.combined.scheme-basic
      tig
      tldr
      tokei
      tree
      websocat
      wget
      # (callPackage ./derivations/pidof.nix { })
      # unrar
      youtube-dl
      ytop # in the future this will be 'bottom'
    ];
  };

  secrets = import ./secrets.nix;
}
