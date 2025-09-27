# NOTE: to use env vars like USER and HOME, use `--impure`
.PHONY: home-linux
home-linux:
	nix run nixpkgs#home-manager -- switch --flake ".#aarch64-linux" --impure

.PHONY: home-darwin
home-darwin:
	nix run nixpkgs#home-manager -- switch --flake ".#aarch64-darwin" --impure

.PHONY: cleanup
cleanup:
	nix store gc

.PHONY:
update:
	nix flake update

.PHONY: darwin-rebuild
darwin-rebuild:
	sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#mac

