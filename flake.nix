{
  description = "Jakub's system config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:kubukoz/home-manager/sbt-password-command-fix";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-ds.url = "git+ssh://git@github.bamtech.co/services-commons/nix-ds?ref=main";
    nix-ds.inputs.nixpkgs.follows = "nixpkgs";
    nix-ds.inputs.flake-utils.follows = "flake-utils";
    hmm.url = "github:kubukoz/hmm";
    hmm.inputs.flake-utils.follows = "flake-utils";
  };

  outputs =
    { self
    , darwin
    , nixpkgs
    , ...
    }@inputs:
    {
      darwinConfigurations.kubukoz-work =
        let
          system = "x86_64-darwin";
          machine = import ./system/machines/work.nix;
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
          modules = [ distributed-builds ./darwin-configuration.nix ./work/system-work.nix ./work/vpn/configuration.nix ];
          specialArgs = builtins.removeAttrs inputs [ "self" "darwin" "nixpkgs" ] // { inherit machine; };
        };
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

          arm-overrides = final: prev:
            {
              inherit (pkgs_x86) niv openconnect scala-cli nix-tree;
              bloop = pkgs_x86.bloop.override { jre = prev.openjdk11; };
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
            ./work/vpn/configuration.nix
            ./work/system-work.nix
          ];
          specialArgs = builtins.removeAttrs inputs [ "self" "darwin" "nixpkgs" ] // { inherit machine; };
        };
    };
}
