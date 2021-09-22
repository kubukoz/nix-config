{ pkgs, config, ... }:
let
  machine = import ../../system/machines;
in
{

  home.packages = with pkgs; [ exa ];

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

    plugins = [
      {
        name = "fzf-tab";
        src = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "cb8a784343a422ba6d8bdf60acaf4714a6a6d5f7";
          sha256 = "0255whjb3k526q1276z21w6lvalx0b2q6jsd571l69ks1bx7mr9g";
        };
      }
      rec {
        name = "zsh-autosuggestions";
        src = "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions";
        file = "${name}.zsh"; # override default with .plugin.zsh
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
      ngc = "nix-collect-garbage -d";
    };

    initExtraBeforeCompInit = ''
      # powerlevel10k
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      source ${./p10k.zsh}
    '';

    initExtra =
      let
        iterm2-shell-integration = builtins.fetchurl {
          url = "https://iterm2.com/shell_integration/zsh";
          sha256 = "1h38yggxfm8pyq3815mjd2rkb411v9g1sa0li884y0bjfaxgbnd4";
        };
      in
        ''
          source ${iterm2-shell-integration}
          source ${toString ./secret-gitlab.sh}
        '';
  };

}
