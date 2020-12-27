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
    # todo new file
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
    # todo new file
    git = {
      enable = true;
      userName = "Jakub Kozłowski";
      userEmail = "kubukoz@gmail.com";

      aliases = {
        dif = "diff --staged";
        rekt = "reset --hard HEAD";
      };

      ignores = [
        ".metals/"
        ".history/"
        "**/project/metals.sbt"
        ".idea/"
        ".vscode/"
        ".bloop/"
        ".scalafmt.conf"
        ".bsp/"
      ];

      includes = [{
        condition = "gitdir:~/dev/";
        path = "~/dev/.gitconfig";
      }];

      extraConfig = { pull = { ff = "only"; }; };
    };
  };

  imports = [ ./zsh ./scala ./node ./secrets-module.nix ];

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
    ];
  };

  secrets = import ./secrets.nix;
}
