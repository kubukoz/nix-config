{ pkgs, machine, lib, ... }: {

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "docker" "docker-compose" ];
    };

    plugins = [
      {
        name = "fzf-tab";
        src = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "7e0eee64df6c7c81a57792674646b5feaf89f263";
          sha256 = "sha256-ixUnuNtxxmiigeVjzuV5uG6rIBPY/1vdBZF2/Qv0Trs=";
        };
      }
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "af6f8a266ea1875b9a3e86e14796cadbe1cfbf08";
          sha256 = "sha256-BjgMhILEL/qdgfno4LR64LSB8n9pC9R+gG7IQWwgyfQ=";
        };
      }
      # {
      #   name = "mill-zsh-completions";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "carlosedp";
      #     repo = "mill-zsh-completions";
      #     rev = "62c8a058bcc7e3c87e66d0230ed6b1e3b2d9934d";
      #     sha256 = "sha256-HRsEFsI3VDiYFgN7xnXQgjTE9IBSZ81DTSltp8CECoM=";
      #   };
      # }
    ];

    localVariables = {
      POWERLEVEL9K_MODE = "awesome-patched";
      HYPHEN_INSENSITIVE = "true";
      COMPLETION_WAITING_DOTS = "true";
      ZSH_HIGHLIGHT_MAXLENGTH = "20";
      JK_MACHINE_NAME = machine.shell-name;
    };

    shellAliases = {
      lsd = "${pkgs.lib.getExe pkgs.eza} --long --header --git --all";
      dps = "${pkgs.lib.getExe pkgs.docker-compose} ps";
      dcp = "${pkgs.lib.getExe pkgs.docker-compose}";
      nss = "${pkgs.lib.getExe pkgs.nix} develop";
      nb = "${pkgs.lib.getExe pkgs.nix} build";
      ngc = "sudo ${pkgs.nix}/bin/nix-collect-garbage -d";
      coursier = "${pkgs.lib.getExe pkgs.coursier}";
    };

    # source /nix/store/yks41y2b7wglvy7dcs8by6325n44m5wk-source/mill-zsh-completions.plugin.zsh

    history = {
      size = 100000;
      # path = "/Users/kubukoz/.zsh_history_video";
    };

    initContent = lib.mkMerge [
      (lib.mkOrder 550 ''
        # powerlevel10k
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        source ${./p10k.zsh}
      '')
      (let
        iterm2-shell-integration = builtins.fetchurl {
          url =
            "https://raw.githubusercontent.com/gnachman/iTerm2/90626bbb104f1ca1f0ed73aff57edf7608ec5f29/Resources/shell_integration/iterm2_shell_integration.zsh";
          sha256 =
            "sha256:1xk6kx5kdn5wbqgx2f63vnafhkynlxnlshxrapkwkd9zf2531bqa";
        };
      in ''
        source ${iterm2-shell-integration}

        # rancher - added via programs/zsh/default.nix
        export PATH="$HOME/.rd/bin:$PATH"
        export PATH="$HOME/Library/Application Support/Coursier/bin:$PATH"
        export PATH="$HOME/.cargo/bin:$PATH"
      '')
    ];
  };

}
