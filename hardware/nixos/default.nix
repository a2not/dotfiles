{...}: let
  enableDesktop = false; # true to enable desktop environment
in {
  imports = [
    ./lima.nix

    (
      if enableDesktop
      then ./desktop.nix
      else {}
    )
  ];
}
