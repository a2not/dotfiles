# nix-config

## home-manager setup

```sh
# install nix
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon

# enable flakes
mkdir -p ~/.config/nix && \
  echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf

# voila
make home

# change default shell to zsh
sudo sed --in-place -e '/auth.*required.*pam_shells.so/s/required/sufficient/g' /etc/pam.d/chsh
chsh -s $(which zsh)
```
