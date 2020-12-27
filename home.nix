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
    ssh = {
      enable = true;
      matchBlocks = {
        gh = {
          host = "github.com";
          hostname = "ssh.github.com";
          port = 443;
        };
        ocado-machine = lib.hm.dag.entryAfter [ "gh" ] {
          host = "kubukoz-pro-oc.local";
          hostname = "kubukoz-pro-oc.local";
          user = "j.kozlowski";
        };
      };
    };
  };

  imports = [ ./zsh ./scala ./node ];

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
      git
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
    ];
  };
}
