{
  description = "Jakub's system config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-21.11";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:kubukoz/home-manager/sbt-password-command-fix";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # todo ref -> slash
    nix-dss.url = "git+ssh://git@github.bamtech.co/jkozlowski/nix-dss?ref=flakes";
    nix-dss.inputs.nixpkgs.follows = "nixpkgs";
    hmm.url = "github:kubukoz/hmm";
    hmm.flake = false;
  };

  outputs = { self, darwin, nixpkgs, home-manager, nix-dss, hmm }:
    {
      darwinConfigurations.kubukoz-work = darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        modules = [ ./darwin-configuration.nix ./work/system-work.nix ];
        specialArgs = {
          machine = import ./system/machines/work.nix;
          inherit home-manager nix-dss hmm;
        };
      };
      darwinConfigurations.kubukoz-max =
        let
          machine = import ./system/machines/max.nix;

          arm-overrides = final: prev:
            let
              mkPackages = source: import source {
                localSystem = "x86_64-darwin";
                config.permittedInsecurePackages = [
                  "openssl-1.0.2u"
                ];
              };

              pkgs_x86 = mkPackages nixpkgs;
            in

            {
              inherit (pkgs_x86) niv openconnect scala-cli nix-tree;
              bloop = pkgs_x86.bloop.override { jre = prev.openjdk11; };
            };
          distributed-builds = {
            nix = {
              distributedBuilds = true;
              buildMachines = let builders = import ./semisecret-builders.nix; in
                [
                  (builders.jk-nixos { sshKey = "/Users/${machine.username}/.ssh/id_ed25519"; })
                ];
            };
          };
        in
        darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            {
              nixpkgs.overlays = [ arm-overrides ];
              nix.extraOptions = ''
                extra-platforms = x86_64-darwin
              '';
            }
            ./darwin-configuration.nix
            ./work/vpn/configuration.nix
          ];
          specialArgs = {
            inherit home-manager hmm machine;
          };
        };
    };
}
