{pkgs, ...}: {
  fonts.packages = with pkgs; [
    udev-gothic-nf
    moralerspace
    nerd-fonts.meslo-lg
  ];
}
