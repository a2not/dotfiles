# Define colors
GREEN  := \033[0;32m
ORANGE := \033[0;33m
NC     := \033[0m # No Color

UNAME_S := $(shell uname -s)
UNAME_M := $(shell uname -m)
# nix spells arm64 as aarch64; everything else matches uname.
NIX_ARCH := $(if $(filter arm64,$(UNAME_M)),aarch64,$(UNAME_M))
DETECTED_SYSTEM := $(NIX_ARCH)-$(if $(filter Darwin,$(UNAME_S)),darwin,linux)

# NOTE: to use env vars like USER and HOME, use `--impure`
# A bare `make` switches whatever host it runs on; the explicit goals pin the
# system, so they can target the other platform on purpose.
.PHONY: home home-linux home-darwin
.DEFAULT_GOAL := home
home: SYSTEM := $(DETECTED_SYSTEM)
home-linux: SYSTEM := aarch64-linux
home-darwin: SYSTEM := aarch64-darwin
home home-linux home-darwin:
	@echo -e "$(GREEN)-> home-manager switch for $(SYSTEM)$(NC)"
	nix run nixpkgs#home-manager -- switch --flake ".#$(SYSTEM)" --impure

.PHONY: init
init:
	lefthook install

.PHONY: sops-age
sops-age:
	@if [ -f /var/lib/sops-nix/keys.txt ]; then \
		echo "age key already exists at /var/lib/sops-nix/keys.txt"; \
	else \
		sudo mkdir -p /var/lib/sops-nix; \
		sudo touch /var/lib/sops-nix/keys.txt; \
		sudo chown "$(id -un):$(id -gn)" /var/lib/sops-nix/keys.txt; \
		sudo chmod 600 /var/lib/sops-nix/keys.txt; \
		sudo vim /var/lib/sops-nix/keys.txt; \
	fi

.PHONY: cleanup
cleanup:
	nix store gc

.PHONY: deep-clean
deep-clean:
	nix store optimise
	sudo nix-collect-garbage -d

.PHONY: kernel-clean
kernel-clean:
	@echo -e "$(ORANGE)Manually delete old kernels since 'nix store gc' won't clean them.$(NC)"
	sudo ls -lah /boot/kernels/

.PHONY: update
update:
	nix flake update

.PHONY: nixos-rebuild
nixos-rebuild:
	sudo nixos-rebuild switch --flake .#lima --impure

# -E (--preserve-env) is needed to preserve env vars like USER and HOME
.PHONY: darwin-rebuild
darwin-rebuild:
	sudo -E nix run nix-darwin/master#darwin-rebuild -- switch --flake .#mac --impure

# TODO: build it on darwin;
.PHONY: img
img:
	nix build .#img --out-link result-aarch64 --impure

# NOTE: alternating vm name with "default" <-> "nixos" b/w generations.
LIMA_VM_NAME := nixos

.PHONY: lima-vm
lima-vm:
	limactl start --name=$(LIMA_VM_NAME) ./xin/lima/nixos.yaml

.PHONY: init-lima
init-lima:
	limactl shell $(LIMA_VM_NAME) -- bash -c "[ -d ~/dotfiles ] || git clone git@github.com:a2not/dotfiles.git ~/dotfiles"
	limactl shell $(LIMA_VM_NAME) -- bash -c "cd ~/dotfiles && git pull"
	limactl shell $(LIMA_VM_NAME) -- bash -c "cd ~/dotfiles && nix-shell -p gnumake -p vim --run 'make sops-age'"
	limactl shell $(LIMA_VM_NAME) -- bash -c "cd ~/dotfiles && nix-shell -p gnumake -p vim --run 'make nixos-rebuild'"
	limactl shell $(LIMA_VM_NAME) -- bash -c "cd ~/dotfiles && nix-shell -p gnumake -p vim --run 'make home-linux'"

