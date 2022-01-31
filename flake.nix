{
  description = "Jakub's system config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    nix-upstream.url = "github:nixos/nix/2.6.0";
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
    , nix-work
    , nix-upstream
    , ...
    }@inputs:
    {
      darwinConfigurations.kubukoz-max =
        let
          system = "aarch64-darwin";
          machine = import ./system/machines/max.nix;
          mkPackages = source: import source {
            localSystem = "x86_64-darwin";
            config.permittedInsecurePackages = [
              "openssl-1.0.2u"
            ];
          };

          pkgs_x86 = mkPackages nixpkgs;

          arm-overrides = final: prev: {
            inherit (pkgs_x86) openconnect scala-cli nix-tree;
            bloop = pkgs_x86.bloop.override { jre = prev.openjdk11; };
            nix_2_6 = nix-upstream.defaultPackage.${system};
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
              nixpkgs.overlays = [ arm-overrides ];
              nix.extraOptions = ''
                extra-platforms = x86_64-darwin
              '';
            }
            distributed-builds
            ./darwin-configuration.nix
            nix-work.darwinModule
          ];
          specialArgs = builtins.removeAttrs inputs [ "self" "darwin" "nixpkgs" ] // { inherit machine; };
        };
    };
}
