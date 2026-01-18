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
	sudo nixos-rebuild switch --flake /etc/nixos#lima

.PHONY: darwin-rebuild
darwin-rebuild:
	sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#mac

# TODO: build it on darwin;
.PHONY: img
img:
	nix build .#img --out-link result-aarch64

.PHONY: lima-nixos-vm
lima-nixos-vm:
	limactl start --name=nixos ./xin/lima/nixos.yaml

.PHONY: lima
lima:
	limactl shell nixos -- bash -c "[ -d ~/dotfiles ] || git clone git@github.com:a2not/dotfiles.git ~/dotfiles"
	limactl shell nixos -- sudo rm -rf /etc/nixos
	limactl shell nixos -- sudo ln -s ~/dotfiles /etc/nixos
	limactl shell nixos -- sudo nixos-rebuild switch --flake /etc/nixos#lima
	limactl shell nixos -- bash -c "mkdir -p ~/.config/sops/age/ ; vim ~/.config/sops/age/keys.txt" # put age key
	limactl shell nixos -- bash -c "cd ~/dotfiles ; make home-linux"
