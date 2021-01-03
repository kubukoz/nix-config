{ pkgs, ... }: {

  fonts = {
    enableFontDir = true;
    fonts = [ pkgs.jetbrains-mono (pkgs.callPackage ./meslo-nerd.nix { }) ];
  };
}
