# Env
export TZ="Asia/Tokyo"
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/go/bin:$PATH

# Lima BEGIN
# Make sure iptables and mount.fuse3 are available
PATH="$PATH:/usr/sbin:/sbin"
export PATH
# Lima END

# Ctrl-R history search with fzf
source <(fzf --zsh)

# edit-command-line with vim
autoload -Uz edit-command-line; zle -N edit-command-line
bindkey "^X^E" edit-command-line

