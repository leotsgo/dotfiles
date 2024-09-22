setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus
setopt auto_cd

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias -- -='cd -'
alias 1='cd -1'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

alias md='mkdir -p'
alias rd=rmdir

function d () {
  if [[ -n $1 ]]; then
    dirs "$@"
  else
    dirs -v | head -n 10
  fi
}
compdef _dirs d

# List directory contents
alias lsa='eza -lah --icons'
alias l='eza -lah --icons'
alias ll='eza -lh --icons'
alias la='eza -lah --icons'
alias ls='eza --icons'
alias l.='eza -d .* --icons'
alias cat='bat'

# Aliases to move around faster
alias kconf='vim ~/.config/kitty/kitty.conf'
alias zshrc='vim $DOTFILES/zsh/zshrc'
alias aliases='vim ~/dotfiles/zsh/aliases.zsh'
alias scripts="cd $SCRIPTS"
alias dotfiles="cd $DOTFILES"
alias sb="cd $NOTES"

# useful aliases
alias vim="nvim"
alias nv="nvim"
alias v="nvim"
alias k="kubectl"

# nvim update with asdf
alias update-nvim-stable='asdf uninstall neovim stable && asdf install neovim stable'
alias update-nvim-nightly='asdf uninstall neovim nightly && asdf install neovim nightly'
alias update-nvim-master='asdf uninstall neovim ref:master && asdf install neovim ref:master'

# update p10k
alias p10k-update='git -C ~/.config/.zsh/powerlevel10k pull'

alias grep='grep --color=auto'
alias lg='lazygit'
alias t='tmux'

function clearzcompdump() {
  local dir="$(pwd)"
  cd $HOME
  rm .zcompdump*
  cd $dir
}
