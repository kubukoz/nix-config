{ pkgs, ... }: {
  imports = [ <home-manager/nix-darwin> ./system/zsh ];

  nix = {
    # Auto upgrade nix package and the daemon service.
    # better not XD
    #  services.nix-daemon.enable = true;
    package = pkgs.nix;

    # https://github.com/LnL7/nix-darwin/issues/145
    # https://github.com/LnL7/nix-darwin/issues/105#issuecomment-567742942
    # fixed according to https://github.com/LnL7/nix-darwin/blob/b3e96fdf6623dffa666f8de8f442cc1d89c93f60/CHANGELOG
    nixPath = pkgs.lib.mkForce [{
      darwin-config = builtins.concatStringsSep ":" [
        "$HOME/.nixpkgs/darwin-configuration.nix"
        "$HOME/.nix-defexpr/channels"
      ];
    }];
  };

  nixpkgs = {
    config.allowUnfree = true;

    overlays = let
      graalvm = self: super:
        let
          jre = self.callPackage ./graalvm { };
          jdk = jre;
        in { inherit jre jdk; };
      bloop = self: super: {
        bloop = self.callPackage (builtins.fetchurl
          "https://raw.githubusercontent.com/Tomahna/nixpkgs/16f488b0902e3b7c096ea08075407e04f99c938d/pkgs/development/tools/build-managers/bloop/default.nix")
          { };
      };
      metals = self: super: {
        vscode-extensions = self.lib.recursiveUpdate super.vscode-extensions {
          scalameta.metals = self.vscode-utils.extensionFromVscodeMarketplace {
            name = "metals";
            publisher = "scalameta";
            version = "1.9.10";
            sha256 = "0v599yssvk358gxfxnyzzkyk0y5krsbp8n4rkp9wb2ncxqsqladr";
          };
          scala-lang.scala = self.vscode-utils.extensionFromVscodeMarketplace {
            name = "scala";
            publisher = "scala-lang";
            version = "0.5.0";
            sha256 = "0rhdnj8vfpcvy771l6nhh4zxyqspyh84n9p1xp45kq6msw22d7rx";
          };
          ms-azuretools.vscode-docker =
            self.vscode-utils.extensionFromVscodeMarketplace {
              name = "vscode-docker";
              publisher = "ms-azuretools";
              version = "1.9.0";
              sha256 = "10xih3djdbxvndlz8s98rf635asjx8hmdza49y67v624i59jdn3x";
            };
        };
      };
    in [ graalvm bloop metals ];
  };

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.kubukoz = import ./home.nix;
  };

  networking.hostName = "kubukoz-pro";

  system.stateVersion = 4;
}
