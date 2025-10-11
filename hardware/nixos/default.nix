{...}: let
  enableDesktop = false; # true to enable desktop environment
in {
  imports = [
    ./lima.nix
    ./packages.nix

    (
      if enableDesktop
      then ./desktop.nix
      else {}
    )
  ];
}
