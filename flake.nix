{
  description = "Jakub's system config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-21.11";
    unstable.url = "github:kubukoz/nixpkgs/bloop-1411";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:kubukoz/home-manager?ref=sbt-password-command-fix";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-dss.url = "git+ssh://git@github.bamtech.co/jkozlowski/nix-dss?ref=flakes";
    nix-dss.inputs.nixpkgs.follows = "nixpkgs";
    hmm.url = "github:kubukoz/hmm";
    hmm.flake = false;
  };

  outputs = { self, darwin, unstable, nixpkgs, home-manager, nix-dss, hmm }:
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
        let arm-overrides = final: prev:
          let
            mkPackages = source: import source {
              localSystem = "x86_64-darwin";
              config.permittedInsecurePackages = [
                "openssl-1.0.2u"
              ];
            };

            pkgs_x86 = mkPackages nixpkgs;
            unstablepkgs_x86 = mkPackages unstable;
          in

          {
            inherit (pkgs_x86) scala-cli niv openconnect;
            # inherit (pkgs_x86) bloop;
            inherit (unstablepkgs_x86) bloop;
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
            machine = import ./system/machines/max.nix;
            inherit home-manager nix-dss hmm;
          };
        };
    };
}
