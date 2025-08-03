{...}: {
  nixpkgs.config.allowUnfree = true;

  imports = [
    ./system.nix
  ];
}
