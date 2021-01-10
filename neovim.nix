{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    extraConfig = "syntax on";
    plugins = with pkgs.vimPlugins; [
      vim-nix
      rec {
        plugin = onedark-vim;
        config = ''
          packadd! ${plugin.pname}
          colorscheme onedark
        '';
      }
    ];
  };
}
