{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    withRuby = false;
    withPython3 = false;
    extraConfig = "syntax on";
    plugins = with pkgs.vimPlugins; [
      vim-nix
      rec {
        plugin = onedark-vim;
        type = "viml";
        config = ''
          packadd! ${plugin.pname}
          colorscheme onedark
        '';
      }
    ];
  };
}
