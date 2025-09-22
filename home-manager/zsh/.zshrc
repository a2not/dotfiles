# Env
export TZ="Asia/Tokyo"
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/go/src/bin:$PATH
export GOPRIVATE=github.sakura.codes

# Lima BEGIN
# Make sure iptables and mount.fuse3 are available
PATH="$PATH:/usr/sbin:/sbin"
export PATH
# Lima END

# NOTE: in nix, zsh integration exist
# I do not have an intension to migrate all to nix here, but its kinda odd state.
# TODO: probably better off split file to that it would work well even without nix home-manager.
if [[ "$IS_NIX_HOME_MANAGED" != "heck yeah!" ]]; then
  # Use neovim as the default editor.
  export EDITOR=nvim
  export VISUAL=nvim
  # alias
  alias vim=nvim
  alias ls="eza --icons"
  alias ll="eza -lah --icons"
  alias update="sudo apt update && sudo apt upgrade -y && sudo snap refresh" # ubunbu update

  # omz
  export ZSH=$HOME/.oh-my-zsh
  plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
  )
  zstyle ':omz:update' mode auto
  zstyle ':omz:update' verbose minimal
  source $ZSH/oh-my-zsh.sh

  # language and tools
  [ -f "$HOME/.cargo/env" ] && source $HOME/.cargo/env

  eval "$(zoxide init zsh)"
  eval "$(starship init zsh)"
  eval "$(~/.local/bin/mise activate zsh)"
fi
