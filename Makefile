# NOTE: to use env vars like USER and HOME, use `--impure`
.PHONY: home
home: update
	nix run nixpkgs#home-manager -- switch --flake ".#aarch64-linux" --impure

.PHONY: cleanup
cleanup:
	nix store gc

.PHONY: update
update:
	nix flake update

.PHONY: darwin-rebuild
darwin-rebuild: update
	darwin-rebuild switch --flake .#mac

