{ pkgs, lib, config, ... }:

let
  inherit (pkgs.callPackage ./lib {}) programsFromTextFile;
in
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
  ];

  home = {
    sessionVariables = {
      LANG = "en_US.UTF-8";
      EDITOR = "nvim";
    };


    packages =

      let
        autoPrograms = programsFromTextFile ./programs/auto.txt;
      in
        autoPrograms ++ map (path: pkgs.callPackage path {}) [
          ./derivations/pidof.nix
        ];
  };
}
