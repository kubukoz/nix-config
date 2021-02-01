self: super: {
  signal-desktop = (self.callPackage ../derivations/signal.nix { });
}
