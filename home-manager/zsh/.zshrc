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

# Disable command-based title changes. instead set fixed tab title; see https://starship.rs/advanced-config/#change-window-title
function set_win_title(){
  echo -ne "\033]0; IDGAF \007"
}
precmd_functions+=(set_win_title) # for wezterm
preexec_functions+=(set_win_title) # for ghostty
