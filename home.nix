{ pkgs, lib, hmm, ... }:

let
  inherit (pkgs.callPackage ./lib { }) attributesFromListFile;
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
    ./programs/ssh
    ./programs/git.nix
    ./programs/neovim.nix
    ./programs/gh
    ./programs/zsh
    ./programs/ngrok
    ./scala
    ./node
    ./vscode
  ];

  home = {
    sessionVariables = {
      LANG = "en_US.UTF-8";
      EDITOR = "nvim";
      # Apparently nix-direnv or direnv sets this to something weird
      GNUPGHOME = "~/.gnupg";
    };


    packages =

      let
        autoPrograms = attributesFromListFile {
          file = ./programs/auto.nix;
          root = pkgs;
        };
      in
      autoPrograms ++ [
        (lib.mkIf pkgs.stdenv.isx86_64 (pkgs.callPackage ./derivations/pidof.nix { }))
        (lib.mkIf pkgs.stdenv.isx86_64 (pkgs.callPackage ./derivations/hmm.nix { src = hmm; }))
      ];
  };
}
