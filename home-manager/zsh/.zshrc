# Env
export TZ="Asia/Tokyo"
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/go/src/bin:$PATH

# Lima BEGIN
# Make sure iptables and mount.fuse3 are available
PATH="$PATH:/usr/sbin:/sbin"
export PATH
# Lima END

if [[ "$IS_NIX_HOME_MANAGED" != "heck yeah!" ]]; then
  [ -f "$HOME/.zshrc_without_nix" ] && source $HOME/.zshrc_without_nix
fi
