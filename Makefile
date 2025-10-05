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

.PHONY: update
update:
	nix flake update

.PHONY: darwin-rebuild
darwin-rebuild:
	sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#mac

.PHONY: lima
lima:
	# TODO: create VM somehow; hopefully by building it on darwin;
	# limactl start https://raw.githubusercontent.com/nixos-lima/nixos-lima/master/nixos.yaml
	limactl shell nixos -- bash -c "git clone git@github.com:a2not/dotfiles.git ~/dotfiles"
	limactl shell nixos -- bash -c "mkdir -p ~/.config/sops/age/ ; vim ~/.config/sops/age/keys.txt" # put age key
	# limactl shell nixos -- bash -c "cd ~/dotfiles ; make home" # TODO: install make initially
	limactl shell nixos -- bash -c "nix run nixpkgs#home-manager -- switch --flake ~/dotfiles#aarch64-linux --impure"
	# TODO: move anything that's possible to nixos system config.
	# like clone repo, home-manager modules, zsh as default, etc.
	# TODO: nixos rebuild; nixos-rebuild boot --flake .#$GUEST_CONFIG_NAME
	# ref: https://github.com/nxmatic/nixos-lima-config/blob/f25c9085502364bba1582e12fcec8e8b7dcec262/setup-nixos.sh
