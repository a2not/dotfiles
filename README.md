# dotfiles

[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

## install Nix

```sh
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon
# enable flakes
mkdir -p ~/.config/nix && \
  echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
```

## home-manager setup

```sh
# prepare age key to decrypt sops-nix. it's in the password manager.
mkdir -p ~/.config/sops/age/
touch ~/.config/sops/age/keys.txt

# voila
make home-linux
```

### (only on ubuntu) set zsh as default shell

```sh
# change default shell to zsh
sudo sed --in-place -e '/auth.*required.*pam_shells.so/s/required/sufficient/g' /etc/pam.d/chsh
chsh -s $(which zsh)
```

## Lima Desktop (ubuntu, NixOS)

see https://github.com/a2not/dotfiles/issues/11

