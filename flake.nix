{
  description = "Jakub's system config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    darwin.url = "github:nix-darwin/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-work.url = "/Users/kubukoz/dev/nix-work";
    nix-work.inputs.nixpkgs.follows = "nixpkgs";
    nix-work.inputs.flake-utils.follows = "flake-utils";
    nix-work.inputs.darwin.follows = "darwin";
    nix-work.inputs.home-manager.follows = "home-manager";
  };

  outputs = { self, darwin, nixpkgs, nix-work, ... }@inputs: {
    darwinConfigurations.kubukoz-max = let
      machine = import ./machines/max.nix;
      inherit (machine) system;

      unstable-overrides = final: prev:
        let
          unstable =
            (import inputs.nixpkgs-unstable { inherit (machine) system; });
        in { inherit (unstable) unison-ucm scala-cli metals; };

      extra-packages = final: prev: { };

      distributed-builds = {
        nix = {
          distributedBuilds = true;
          buildMachines = let
            builders = import ./semisecret-builders.nix;
            sshKey = "${machine.homedir}/.ssh/id_ed25519";
          in [
            # (builders.jk-nixos { inherit sshKey; maxJobs = 2; })
            (builders.jk-nixbuild { inherit sshKey; })
            # (builders.jk-rasp { inherit sshKey; })
          ];
        };
      };
    in darwin.lib.darwinSystem {
      inherit system;
      modules = [
        {
          nixpkgs.overlays = [ unstable-overrides extra-packages ];
          nix.extraOptions = ''
            extra-platforms = x86_64-darwin
          '';
        }
        distributed-builds
        ./darwin-configuration.nix
        nix-work.darwinModules.default
      ];
      specialArgs = builtins.removeAttrs inputs [ "self" "darwin" "nixpkgs" ]
        // {
          inherit machine;
        };
    };
  };
}
