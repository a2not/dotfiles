export TZ="Asia/Tokyo"
export PATH=$HOME/.local/bin:$PATH

export ZSH=$HOME/.oh-my-zsh
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)
zstyle ':omz:update' mode auto
zstyle ':omz:update' verbose minimal
source $ZSH/oh-my-zsh.sh

# Use neovim as the default editor.
export EDITOR=nvim
export VISUAL=nvim

alias vim=nvim
alias l="eza -lah --icons"
alias ls="eza --icons"
alias sl="eza --icons"

export GOPRIVATE=github.sakura.codes

source $HOME/.cargo/env

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(~/.local/bin/mise activate zsh)"

# ubuntu update
alias update="sudo apt update && sudo apt upgrade -y && sudo snap refresh"

# Lima BEGIN
# Make sure iptables and mount.fuse3 are available
PATH="$PATH:/usr/sbin:/sbin"
export PATH
# Lima END
