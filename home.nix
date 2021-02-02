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
    ./programs/gh.nix
    ./programs/neovim.nix
    ./programs/zsh
    ./programs/openconnect
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
      awscli
      cachix
      ctop
      dhall
      dhall-json
      dhall-lsp-server
      ffmpeg
      gnuplot
      httpie
      imgcat
      lame
      ngrok
      niv
      nixfmt
      pirate-get
      plantuml
      postgresql
      pstree
      python2
      redis
      signal-desktop
      sl
      speedtest-cli
      texlive.combined.scheme-basic
      tig
      tldr
      tokei
      tree
      websocat
      wget
      (callPackage ./derivations/pidof.nix { })
      unrar
      youtube-dl
      bottom
    ];

    # todo: remove user-specific path, get HM path another way, get HM to actually do this link... get Spotlight to use it.
    file."Applications".source =
      "/nix/var/nix/profiles/per-user/kubukoz/home-manager/home-path/Applications";
  };

}
