# ssh agent
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null


eval "$(~/.local/bin/mise activate zsh)"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
# plug "$HOME/.asdf/asdf.sh"
#plug "${XDG_CONFIG_HOME:-$HOME/.config}/asdf-direnv/zshrc"
plug "zap-zsh/supercharge"
plug "zdharma-continuum/fast-syntax-highlighting"
plug "hlissner/zsh-autopair"
plug "romkatv/powerlevel10k"

# ZSH HISTORY
HISTSIZE=100000000
SAVEHIST=100000000
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
HISTFILE=~/.config/.zsh/.zsh_history

# exports and path stuff
export ASDF_GOLANG_MOD_VERSION_ENABLED=true
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export SUDO_EDITOR=nvim
export EDITOR=nvim
export GOPATH="$HOME/go"
export ZSH_COMPDUMP=~/.cache/.zcompdump-$HOST
# Rofi custom launchers and powermenu
export PATH=$HOME/.config/rofi/scripts:$PATH
# Silences direnv console output
export DIRENV_LOG_FORMAT=""
# Fly.io
export FLYCTL_INSTALL=~/.fly
export PATH="$FLYCTL_INSTALL/bin:$PATH"
# Deta
export PATH=~/.deta/bin:$PATH
# PATH=$PATH:$(asdf where nodejs)/bin # adds node to PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:/usr/bin"
export PATH="$PATH:$HOME/scripts"
# if [ -f /etc/os-release ]; then
#   . /etc/os-release;
#   case $NAME in 
#         "Arch Linux")
#           PATH+=:~/.cargo/bin
#           ;;
#   esac
# fi
# PATH+="$(where rust)/bin"

# append completions to fpath
# fpath=(${ASDF_DIR}/completions $fpath)
fpath+=$HOME/.config/.zsh/completions
# The next line enables shell command completion for kubectl
# source <(kubectl completion zsh)
eval "$(mise hook-env)"
source <($(which kubectl) completion zsh)
# initialise completions with ZSH's compinit
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select # Enable tab completion menu
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' '+l:|=* r:|=*' # Enable tab completion based on what's already written
plug "$HOME/.config/.zsh/aliases.zsh"

# The next line updates PATH for the Google Cloud SDK.
if [ -f ~/google-cloud-sdk/path.zsh.inc ]; then . ~/google-cloud-sdk/path.zsh.inc; fi

# The next line enables shell command completion for gcloud.
if [ -f ~/google-cloud-sdk/completion.zsh.inc ]; then . ~/google-cloud-sdk/completion.zsh.inc; fi

# autoload edit command in vim
autoload edit-command-line
zle -N edit-command-line
bindkey "^e" edit-command-line
bindkey '^H' backward-kill-word
bindkey '\t' menu-select "$terminfo[kcbt]" menu-select
bindkey -M menuselect '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete
# export GTK_IM_MODULE=cedilla
# export QT_IM_MODULE=cedilla

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# opam configuration
[[ ! -r /home/leodiber/.opam/opam-init/init.zsh ]] || source /home/leodiber/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

