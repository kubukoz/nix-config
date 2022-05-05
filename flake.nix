{
  description = "Jakub's system config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    nixpkgs-legacy.url = "github:Tomahna/nixpkgs/bloop";
    flake-utils.url = "github:numtide/flake-utils";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    gitignore-source.url = "github:hercules-ci/gitignore.nix";
    gitignore-source.inputs.nixpkgs.follows = "nixpkgs";
    hmm.url = "github:kubukoz/hmm";
    hmm.inputs.flake-utils.follows = "flake-utils";
    hmm.inputs.gitignore-source.follows = "gitignore-source";
    hmm.inputs.nixpkgs.follows = "nixpkgs";
    dynein.url = "github:kubukoz/dynein";
    dynein.inputs.flake-utils.follows = "flake-utils";
    dynein.inputs.gitignore-source.follows = "gitignore-source";
    dynein.inputs.nixpkgs.follows = "nixpkgs";

    # some dirty dancing to make sure only one nixpkgs is used
    nix-ds.url = "git+ssh://git@github.bamtech.co/services-commons/nix-dss?ref=main";
    nix-ds.inputs.nixpkgs.follows = "nixpkgs";
    nix-ds.inputs.flake-utils.follows = "flake-utils";

    nix-work.url = "git+ssh://git@github.bamtech.co/jkozlowski/nix-work?ref=main";
    nix-work.inputs.nixpkgs.follows = "nixpkgs";
    nix-work.inputs.flake-utils.follows = "flake-utils";
    nix-work.inputs.nix-ds.follows = "nix-ds";

  };

  outputs =
    { self
    , darwin
    , nixpkgs
    , nixpkgs-legacy
    , nix-work
    , ...
    }@inputs:
    {
      darwinConfigurations.kubukoz-max =
        let
          machine = import ./system/machines/max.nix;
          inherit (machine) system;
          mkIntelPackages = source: import source {
            localSystem = "x86_64-darwin";
          };

          pkgs_x86 = mkIntelPackages nixpkgs;
          pkgs_legacy = mkIntelPackages nixpkgs-legacy;

          arm-overrides = final: prev: {
            inherit (pkgs_x86) openconnect scala-cli;
            bloop = pkgs_x86.bloop.override { jre = prev.openjdk11; };
          };

          extra-packages = final: prev: {
            hmm = inputs.hmm.defaultPackage.${system};
            dynein = inputs.dynein.defaultPackage.${system};
          };

          distributed-builds = {
            nix = {
              distributedBuilds = true;
              buildMachines = let builders = import ./semisecret-builders.nix; in
                [
                  (builders.jk-nixos { sshKey = "${machine.homedir}/.ssh/id_ed25519"; maxJobs = 2; })
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
            nix-work.darwinModules.all
          ];
          specialArgs = builtins.removeAttrs inputs [ "self" "darwin" "nixpkgs" ] // { inherit machine; };
        };
    };
}
