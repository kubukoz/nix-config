{ pkgs, lib, system, ... }:

let inherit (pkgs.callPackage ./lib { }) attributesFromListFile;
in {
  programs = {
    bat = {
      enable = true;
      config.theme = "ansi";
    };
    less.enable = true;
    broot.enable = true;
    fzf.enable = true;
    htop.enable = true;
    jq.enable = true;
    gpg.enable = true;
  };

  imports = [
    ./fonts
    ./programs/ssh
    ./programs/git.nix
    ./programs/neovim.nix
    ./programs/gh
    ./programs/zsh
    ./programs/ngrok
    ./scala
    ./vscode
  ];

  home = {
    sessionVariables = {
      LANG = "en_US.UTF-8";
      EDITOR = "nvim";
    };

    packages =

      let
        autoPrograms = attributesFromListFile {
          file = ./programs/auto.nix;
          root = pkgs;
        };
        create-test-file = pkgs.writeScriptBin "create-test-file" ''
          # Script to create a test file from a main source file path
          # Usage: ./create-test-file.sh <path-to-main-file>

          if [ $# -eq 0 ]; then
              echo "Usage: $0 <path-to-main-file>"
              echo "Example: $0 module/src/main/scala/com/kubukoz/Demo.scala"
              exit 1
          fi

          MAIN_FILE="$1"

          # Replace /src/main/scala/ with /src/test/scala/ using sed
          TEST_FILE=$(echo "$MAIN_FILE" | sed 's|/src/main/scala/|/src/test/scala/|')

          # Get the filename without extension and add "Spec"
          # Extract directory path
          DIR_PATH=$(dirname "$TEST_FILE")
          # Extract filename
          FILENAME=$(basename "$TEST_FILE" .scala)
          # Create new filename with Spec suffix
          TEST_FILE="''${DIR_PATH}/''${FILENAME}Spec.scala"

          # Create parent directories if they don't exist
          mkdir -p "$(dirname "$TEST_FILE")"

          # Create the file
          touch "$TEST_FILE"

          echo "Created test file: $TEST_FILE"
        '';
      in autoPrograms ++ [
        (lib.mkIf pkgs.stdenv.isx86_64
          (pkgs.callPackage ./derivations/pidof.nix { }))
        (pkgs.callPackage ./derivations/smithy-lsp.nix { })
        (pkgs.callPackage ./node2nix { }).dexsearch
        create-test-file
      ];

    stateVersion = "22.05";
  };
}
