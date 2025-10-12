{...}: let
  enableDesktop = true; # true to enable desktop environment
in {
  imports = [
    ./lima.nix
    ./configuration.nix
    ./packages.nix

    (
      if enableDesktop
      then ./desktop.nix
      else {}
    )
  ];
}
