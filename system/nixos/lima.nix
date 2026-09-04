# NOTE: ref -> https://github.com/nixos-lima/nixos-lima-config-sample/blob/42218c18dc560ac16126e4925ab42f6594bcfdc3/nixos-lima-config.nix
{
  modulesPath,
  pkgs,
  lib,
  nixos-lima,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    nixos-lima.nixosModules.lima
  ];

  networking.hostName = "lima-nixos";

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Give users in the `wheel` group additional rights when connecting to the Nix daemon
  # This simplifies remote deployment to the instance's nix store.
  nix.settings.trusted-users = ["@wheel"];

  # Read Lima configuration at boot time and run the Lima guest agent
  services.lima.enable = true;

  # ssh
  services.openssh.enable = true;

  security = {
    sudo.wheelNeedsPassword = false;
  };

  # system mounts
  boot.loader.grub = {
    device = "nodev";
    efiSupport = true;
    efiInstallAsRemovable = true;
    # NOTE: workaround for /boot partition too small
    # ```
    # cannot copy /nix/store/6b9mqhkmhz2lbi4qamh0qpm3mdl731zj-linux-7.1.5/Image to
    #   /boot/kernels/6b9mqhkmhz2lbi4qamh0qpm3mdl731zj-linux-7.1.5-Image.tmp: No space left on device
    # Failed to install bootloader
    # ```
    # copyKernels = false; # Kernels live in /nix/store, not the small ESP.
    # configurationLimit = 10;
  };
  fileSystems."/boot" = {
    device = lib.mkForce "/dev/vda1"; # /dev/disk/by-label/ESP
    fsType = "vfat";
  };
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    autoResize = true;
    fsType = "ext4";
    options = ["noatime" "nodiratime" "discard"];
  };

  # misc
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelParams = ["console=tty0"];

  system.stateVersion = "25.11";
}
