{ pkgs, ... }: {
  fonts.fontconfig.enable = true;
  home.packages = [ pkgs.jetbrains-mono pkgs.meslo-lgs-nf ];
}
