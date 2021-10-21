self: super: {
  coursier-tools = self.callPackage ../coursier {};
  coursier = super.unstable.coursier;
}
