{
  description = "Jakub's system config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?rev=2182da1de8081da92f3c5c04e3fa5e5452266afc";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    unstable.url = "github:nixos/nixpkgs";
    nix-dss.url = "git+ssh://git@github.bamtech.co/jkozlowski/nix-dss?ref=flakes";
    nix-dss.inputs.nixpkgs.follows = "nixpkgs";
    hmm.url = "github:kubukoz/hmm";
    hmm.flake = false;
  };

  outputs = { self, darwin, nixpkgs, home-manager, unstable, nix-dss, hmm }:
    {
      darwinConfigurations.kubukoz-work = darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        modules = [ ./darwin-configuration.nix ];
        specialArgs = {
          machine = import ./system/machines/work.nix;
          inherit home-manager unstable nix-dss hmm;
        };
      };
    };
}
