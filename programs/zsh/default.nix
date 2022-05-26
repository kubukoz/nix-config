{ pkgs, config, machine, ... }:
{

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "docker" "docker-compose" ];
    };

    enableAutosuggestions = true;

    plugins = [
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
      }
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.zsh-nix-shell;
      }
    ];

    localVariables = {
      POWERLEVEL9K_MODE = "awesome-patched";
      HYPHEN_INSENSITIVE = "true";
      COMPLETION_WAITING_DOTS = "true";
      ZSH_HIGHLIGHT_MAXLENGTH = "20";
      JK_MACHINE_NAME = machine.shell-name;
    };

    shellAliases = {
      lsd = "exa --long --header --git --all";
      dps = "docker-compose ps";
      dcp = "docker-compose";
      nss = "nix-shell";
      nb = "nix-build";
      ngc = "sudo nix-collect-garbage -d";
      coursier = "cs";
    };

    initExtraBeforeCompInit = ''
      # powerlevel10k
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      source ${./p10k.zsh}
    '';

    history = {
      size = 100000;
    };

    initExtra =
      let
        iterm2-shell-integration = builtins.fetchurl {
          url = "https://iterm2.com/shell_integration/zsh";
          sha256 = "1h38yggxfm8pyq3815mjd2rkb411v9g1sa0li884y0bjfaxgbnd4";
        };
      in
      ''
        source ${iterm2-shell-integration}
      '';
  };

}
