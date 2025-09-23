{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  fonts.packages = with pkgs; [
    udev-gothic-nf
    moralerspace-nf
    nerd-fonts.meslo-lg
  ];

  environment.systemPackages = with pkgs; [
    alejandra

    # TODO: config files for these
    ghostty
    wezterm

    "1password-gui"
    "1password"
  ];

  # TODO: install actual zen itself; https://github.com/a2not/nix-config/issues/3
  environment.etc = {
    "1password/custom_allowed_browsers" = {
      text = ''
        .zen-wrapped
      '';
      mode = "0755";
    };
  };
}
