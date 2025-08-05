_default:
    just --list

cleanup:
  nix store gc

update:
  nix flake update

build profile: update
  nix build --json --no-link --print-build-logs ".#{{ profile }}"

# NOTE: to use env vars like USER and HOME, use `--impure`
home profile="aarch64-linux": update
  nix run nixpkgs#home-manager -- switch --flake ".#{{ profile }}" --impure

darwin-rebuild: update
  darwin-rebuild switch --flake .#mac

