{
  description = "Jakub's system config";

  inputs = {
    nixpkgs.url = "github:kubukoz/nixpkgs/options-json-darwin";
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
    dynein.url = "github:kubukoz/dynein";
    dynein.inputs.flake-utils.follows = "flake-utils";
    dynein.inputs.gitignore-source.follows = "gitignore-source";
    dynein.inputs.nixpkgs.follows = "nixpkgs";

    # some dirty dancing to make sure only one nixpkgs is used
    nix-ds.url = "git+ssh://git@github.bamtech.co/services-commons/nix-ds?ref=main";
    nix-ds.inputs.nixpkgs.follows = "nixpkgs";
    nix-ds.inputs.flake-utils.follows = "flake-utils";

    nix-work.url = "git+ssh://git@github.bamtech.co/jkozlowski/nix-work?ref=main";
    nix-work.inputs.nixpkgs.follows = "nixpkgs";
    nix-work.inputs.flake-utils.follows = "flake-utils";
    nix-work.inputs.nix-ds.follows = "nix-ds";
    nix-work.inputs.home-manager.follows = "home-manager";
    nix-work.inputs.darwin.follows = "darwin";

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
          mkIntelPackages = source: import source {
            localSystem = "x86_64-darwin";
          };

          pkgs_x86 = mkIntelPackages nixpkgs;

          arm-overrides = final: prev: {
            inherit (pkgs_x86) openconnect;
            scala-cli = pkgs_x86.scala-cli.override { jre = prev.openjdk17; };
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
                  (builders.jk-nixbuild { sshKey = "${machine.homedir}/.ssh/id_ed25519"; })
                  # (builders.jk-work { sshKey = "${machine.homedir}/.ssh/id_ed25519"; })
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
      darwinConfigurations.kubukoz-work =
        let
          system = "x86_64-darwin";
          machine = import ./machines/work.nix;

          extra-packages = final: prev: {
            hmm = inputs.hmm.defaultPackage.${system};
            dynein = inputs.dynein.defaultPackage.${system};
          };
          distributed-builds = {
            nix = {
              distributedBuilds = true;
              buildMachines = let builders = import ./semisecret-builders.nix; in
                [
                  (builders.jk-max { sshKey = "${machine.homedir}/.ssh/id_ed25519"; })
                ];
            };
          };
        in
        darwin.lib.darwinSystem {
          inherit system;
          modules = [
            ./darwin-configuration.nix
            nix-work.darwinModules.all
            { nixpkgs.overlays = [ extra-packages ]; }
            distributed-builds
          ];
          specialArgs = builtins.removeAttrs inputs [ "self" "darwin" "nixpkgs" ] // { inherit machine; };
        };
    };
}
