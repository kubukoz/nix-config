{
  description = "Jakub's system config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.utils.follows = "flake-utils";
    gitignore-source.url = "github:hercules-ci/gitignore.nix";
    gitignore-source.inputs.nixpkgs.follows = "nixpkgs";
    hmm.url = "github:kubukoz/hmm";
    # hmm.inputs.flake-utils.follows = "flake-utils";
    # hmm.inputs.gitignore-source.follows = "gitignore-source";
    # hmm.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self
    , darwin
    , nixpkgs
    , ...
    }@inputs:
    {
      darwinConfigurations.kubukoz-max =
        let
          machine = import ./machines/max.nix;
          inherit (machine) system;

          arm-overrides = final: prev: {
            bloop = prev.pkgsx86_64Darwin.bloop.override { jre = prev.jre; };
          };

          extra-packages = final: prev: {
            hmm = inputs.hmm.defaultPackage.${system};
          };

          distributed-builds = {
            nix = {
              distributedBuilds = true;
              buildMachines = let builders = import ./semisecret-builders.nix; in
                [
                  (builders.jk-nixos { sshKey = "${machine.homedir}/.ssh/id_ed25519"; maxJobs = 2; })
                  (builders.jk-nixbuild { sshKey = "${machine.homedir}/.ssh/id_ed25519"; })
                ];
            };
          };
        in
        darwin.lib.darwinSystem {
          inherit system;
          modules = [
            {
              nixpkgs.overlays = [
                arm-overrides
                extra-packages
              ];
              nix.extraOptions = ''
                extra-platforms = x86_64-darwin
              '';
            }
            distributed-builds
            ./darwin-configuration.nix
          ];
          specialArgs = builtins.removeAttrs inputs [ "self" "darwin" "nixpkgs" ] // { inherit machine; };
        };
    };
}
