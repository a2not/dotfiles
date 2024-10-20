apply:
  darwin-rebuild switch --flake .#mac

cleanup:
  nix store gc

update:
  nix flake update
