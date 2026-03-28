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
	sudo rm -rf /etc/nixos
	sudo ln -s ~/dotfiles /etc/nixos
	sudo nixos-rebuild switch --flake /etc/nixos#lima --impure

.PHONY: darwin-rebuild
darwin-rebuild:
	sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#mac --impure

# TODO: build it on darwin;
.PHONY: img
img:
	nix build .#img --out-link result-aarch64

# NOTE: alternating vm name with "default" <-> "nixos" b/w generations.
LIMA_VM_NAME := nixos

.PHONY: lima-vm
lima-vm:
	limactl start --name=$(LIMA_VM_NAME) ./xin/lima/nixos.yaml

.PHONY: lima-vm-nixos
lima-vm-nixos:
	$(MAKE) lima-vm LIMA_VM_NAME=nixos

.PHONY: lima-vm-default
lima-vm-default:
	$(MAKE) lima-vm LIMA_VM_NAME=default

.PHONY: init-lima
init-lima:
	limactl shell $(LIMA_VM_NAME) -- bash -c "[ -d ~/dotfiles ] || git clone git@github.com:a2not/dotfiles.git ~/dotfiles"
	limactl shell $(LIMA_VM_NAME) -- bash -c "sudo rm -rf /etc/nixos"
	limactl shell $(LIMA_VM_NAME) -- bash -c "sudo ln -s ~/dotfiles /etc/nixos"
	limactl shell $(LIMA_VM_NAME) -- bash -c "sudo nixos-rebuild switch --flake /etc/nixos#lima"
	limactl shell $(LIMA_VM_NAME) -- bash -c "mkdir -p ~/.config/sops/age/ ; vim ~/.config/sops/age/keys.txt" # put age key
	limactl shell $(LIMA_VM_NAME) -- bash -c "cd ~/dotfiles ; make home-linux"

.PHONY: init-lima-nixos
init-lima-nixos:
	$(MAKE) init-lima LIMA_VM_NAME=nixos

.PHONY: init-lima-default
init-lima-default:
	$(MAKE) init-lima LIMA_VM_NAME=default
