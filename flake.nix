{
  description = "Jakub's system config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?rev=2182da1de8081da92f3c5c04e3fa5e5452266afc";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, darwin, nixpkgs }:
    {

      darwinConfigurations.kubukoz-work = darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        modules = [ ./darwin-configuration.nix ];
        specialArgs = {
          machine = import ./system/machines/work.nix;
        };
      };
    };
}
