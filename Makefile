# NOTE: to use env vars like USER and HOME, use `--impure`
.PHONY: home
home:
	nix run nixpkgs#home-manager -- switch --flake ".#aarch64-linux" --impure

.PHONY: cleanup
cleanup:
	nix store gc

.PHONY:
update:
	nix flake update

.PHONY: darwin-rebuild
darwin-rebuild:
	darwin-rebuild switch --flake .#mac --impure

