{ pkgs, ... }: {

  fonts = {
    fontDir.enable = true;
    fonts = [ pkgs.jetbrains-mono (pkgs.callPackage ./meslo-nerd.nix { }) ];
  };
}
