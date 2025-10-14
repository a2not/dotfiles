{...}: let
  enableDesktop = false; # true to enable desktop environment
in {
  imports = [
    ./lima.nix
    ./configuration.nix
    ./packages.nix
    # ./user.nix

    (
      if enableDesktop
      then ./desktop.nix
      else {}
    )
  ];
}
