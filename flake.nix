{
  description = "Jakub's system config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hmm.url = "github:kubukoz/hmm";
    hmm.inputs.flake-utils.follows = "flake-utils";
    hmm.inputs.nixpkgs.follows = "nixpkgs";
    nix-work.url = "/Users/kubukoz/dev/nix-work";
    nix-work.inputs.nixpkgs.follows = "nixpkgs";
    nix-work.inputs.flake-utils.follows = "flake-utils";
    nix-work.inputs.darwin.follows = "darwin";
    nix-work.inputs.home-manager.follows = "home-manager";
  };

  outputs =
    { self
    , darwin
    , nixpkgs
    , nix-work
    , ...
    }@inputs:
    {
      darwinConfigurations.kubukoz-max =
        let
          machine = import ./machines/max.nix;
          inherit (machine) system;

          unstable-overrides = final: prev: {
            scala-cli = (import inputs.nixpkgs-master { inherit (machine) system; }).scala-cli.override { jre = final.jre; };
            # pkgsx86_64Darwin.bloop = (import inputs.nixpkgs-master { inherit (machine) system; }).pkgsx86_64Darwin.bloop.override { jre = final.jre; };
          };

          extra-packages = final: prev: {
            hmm = inputs.hmm.packages.${system}.default;
          };

          arm-overrides = final: prev: {
            bloop = prev.pkgsx86_64Darwin.bloop.override { jre = final.jre; };
          };

          distributed-builds = {
            nix = {
              distributedBuilds = true;
              buildMachines = let builders = import ./semisecret-builders.nix; in
                [
                  # (builders.jk-nixos { sshKey = "${machine.homedir}/.ssh/id_ed25519"; maxJobs = 2; })
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
                unstable-overrides
                extra-packages
                arm-overrides
              ];
              nix.extraOptions = ''
                extra-platforms = x86_64-darwin
              '';
            }
            distributed-builds
            ./darwin-configuration.nix
            # nix-work.darwinModules.default
          ];
          specialArgs = builtins.removeAttrs inputs [ "self" "darwin" "nixpkgs" ] // { inherit machine; };
        };
    };
}
