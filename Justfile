_default:
    just --list

cleanup:
  nix store gc

update:
  nix flake update

build profile:
    nix build --json --no-link --print-build-logs ".#{{ profile }}"

home-manager-build profile="aarch64-linux":
    just build "homeConfigurations.{{ profile }}.activationPackage"

home-manager-switch profile="aarch64-linux":
    nix run nixpkgs#home-manager -- switch --flake ".#{{ profile }}" --impure

apply:
  darwin-rebuild switch --flake .#mac

