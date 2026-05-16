# NOTE: to use env vars like USER and HOME, use `--impure`
.PHONY: home-linux
home-linux:
	nix run nixpkgs#home-manager -- switch --flake ".#aarch64-linux" --impure

.PHONY: home-darwin
home-darwin:
	nix run nixpkgs#home-manager -- switch --flake ".#aarch64-darwin" --impure

.PHONY: sops-age
sops-age:
	mkdir -p ~/.config/sops/age/
	vim ~/.config/sops/age/keys.txt

.PHONY: cleanup
cleanup:
	nix store gc

.PHONY: deep-clean
deep-clean:
	sudo nix-collect-garbage -d

.PHONY: update
update:
	nix flake update

.PHONY: nixos-rebuild
nixos-rebuild:
	sudo nixos-rebuild switch --flake .#lima

.PHONY: darwin-rebuild
darwin-rebuild:
	sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#mac

# TODO: build it on darwin;
.PHONY: img
img:
	nix build .#img --out-link result-aarch64

# NOTE: alternating vm name with "default" <-> "nixos" b/w generations.
LIMA_VM_NAME := nixos

.PHONY: lima-vm
lima-vm:
	limactl start --name=$(LIMA_VM_NAME) ./xin/lima/nixos.yaml

.PHONY: init-lima
init-lima:
	limactl shell $(LIMA_VM_NAME) -- bash -c "[ -d ~/dotfiles ] || git clone git@codeberg.org:a2not/dotfiles.git ~/dotfiles"
	limactl shell $(LIMA_VM_NAME) -- bash -c "cd ~/dotfiles ; git pull"
	limactl shell $(LIMA_VM_NAME) -- bash -c "cd ~/dotfiles ; sudo nixos-rebuild boot --flake .#lima"
	limactl shell $(LIMA_VM_NAME) -- bash -c "[ -d ~/.config/sops/age ] || mkdir -p ~/.config/sops/age/ && vim ~/.config/sops/age/keys.txt" # put age key
	limactl shell $(LIMA_VM_NAME) -- bash -c "cd ~/dotfiles ; make home-linux"

