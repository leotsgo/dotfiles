# ~~~~~~~~~~~~~~~~ SSH ~~~~~~~~~~~~~~~~~~~~~~


unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null

# ~~~~~~~~~~~~~~~~ p10k source ~~~~~~~~~~~~~~~


if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ~~~~~~~~~~ Environment Variables ~~~~~~~~~~


eval "$(~/.local/bin/mise activate zsh)"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export SUDO_EDITOR=nvim
export EDITOR=nvim
export ZSH_COMPDUMP=~/.cache/.zcompdump-$HOST
export GOPATH="$HOME/go"
export SCRIPTS="$HOME/scripts"

# ~~~~~~~~~~~~~~~~ Plugin Manager ~~~~~~~~~~~~

if [ ! -f $HOME/.local/share/zap/zap.zsh ]; then
  zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) -k --branch release-v1
fi

[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zdharma-continuum/fast-syntax-highlighting"
plug "hlissner/zsh-autopair"
plug "romkatv/powerlevel10k"

# ~~~~~~~~~~~~~~~ History ~~~~~~~~~~~~~~~~~~~


HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.config/.zsh/.zsh_history
setopt INC_APPEND_HISTORY # new history lines are added to the $HISTFILE incrementally (as soon as they are entered)
setopt HIST_IGNORE_SPACE  # Don't save when prefixed with space
setopt HIST_IGNORE_DUPS   # Don't save duplicate lines
setopt SHARE_HISTORY      # Share history between sessions

# ~~~~~~~~~~~~~~~ Path ~~~~~~~~~~~~~~~~~~~~~


setopt extended_glob null_glob

path=(
  $path
  $HOME/.krew/bin
  $SCRIPTS
  $HOME/.local/bin
  /usr/bin
  $HOME/go/bin
)

typeset -U path
path=($^path(N-/))
export PATH

# ~~~~~~~~~~~~~~~ Completions ~~~~~~~~~~~~~~


fpath+=$HOME/.config/.zsh/completions
eval "$(mise hook-env)"
source <($(which kubectl) completion zsh)

autoload -Uz compinit
compinit -u
# Enable tab completion menu
zstyle ':completion:*' menu select 
 # Enable tab completion based on what's already written
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' '+l:|=* r:|=*'
plug "$HOME/.config/.zsh/aliases.zsh"

# autoload edit command in vim
autoload edit-command-line
zle -N edit-command-line
bindkey "^e" edit-command-line
bindkey '^H' backward-kill-word

# ~~~~~~~~~~~~~~~ Sourcing ~~~~~~~~~~~~~~


source <(fzf --zsh)
source "$HOME/.config/.zsh/aliases.zsh"
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh



