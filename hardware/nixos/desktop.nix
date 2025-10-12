{...}: {
  # NOTE: ref: https://wiki.nixos.org/wiki/Category:Desktop_environment

  ## GNOME
  # services.displayManager.gdm.enable = true;
  # services.desktopManager.gnome.enable = true;

  ## KDE Plasma 6
  services.xserver.enable = true; # optional
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;
}
