_default:
    just --list

cleanup:
  nix store gc

update:
  nix flake update

build profile:
  nix build --json --no-link --print-build-logs ".#{{ profile }}"

# NOTE: to use env vars like USER and HOME, use `--impure`
home profile="aarch64-linux":
  nix run nixpkgs#home-manager -- switch --flake ".#{{ profile }}" --impure

darwin-rebuild:
  darwin-rebuild switch --flake .#mac

