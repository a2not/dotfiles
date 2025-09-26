{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  fonts.packages = with pkgs; [
    udev-gothic-nf
    moralerspace
    nerd-fonts.meslo-lg
  ];

  environment.systemPackages = with pkgs; [
    git
    neovim
    just
    alejandra

    # TODO: config files for this
    wezterm

    _1password-gui
    _1password-cli

    # TODO: migrate them. They're in brew for now
    # qemu
    # awscli
    # ripgrep
    # exiftool
    # pipx
  ];

  # TODO: install actual zen itself; https://github.com/a2not/nix-config/issues/3
  # environment.etc = {
  #   "1password/custom_allowed_browsers" = {
  #     text = ''
  #       .zen-wrapped
  #     '';
  #     mode = "0755";
  #   };
  # };
}
