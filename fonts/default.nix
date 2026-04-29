{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;
  home.packages = [
    # nerd-fonts variant avoids the gftools -> ffmpeg-python dep chain,
    # whose tests invoke ffmpeg in the darwin sandbox and get SIGKILL'd.
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.meslo-lgs-nf
  ];
}
