{pkgs, ...}: {
  fonts.packages = with pkgs; [
    udev-gothic-nf
    moralerspace
    nerd-fonts.meslo-lg
  ];

  programs.zsh.enable = true;
  environment.systemPackages = with pkgs; [
    git
    neovim
    starship
    gnumake
  ];
}
