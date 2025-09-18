##############################################
# Zinit bootstrap
##############################################
### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
  print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Plugin Manager…%f"
  command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
  command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
    print -P "%F{33} %F{34}Installation successful.%f%b" || \
    print -P "%F{160} The clone has failed.%f%b"
fi
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"


##############################################
# Plugins (foundations)
# - load completions first so compinit can see them
##############################################
zinit light zsh-users/zsh-completions


##############################################
# Completion system
##############################################
autoload -Uz compinit && compinit

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no


##############################################
# Completion UI (fzf-tab) — AFTER compinit
##############################################
zinit light Aloxaf/fzf-tab
# fzf-tab options (Tab accepts)
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
zstyle ':fzf-tab:complete:*' fzf-preview \
  '([[ -d $realpath ]] && ls --color $realpath) || (file -b $realpath; head -n 200 $realpath 2>/dev/null)'


##############################################
# ZLE enhancements (order matters: autosuggest -> syntax highlight)
##############################################
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting

# Oh-My-Zsh snippets (optional extras)
zinit snippet OMZP::git
zinit snippet OMZP::command-not-found

# Replay any directory changes done while loading plugins
zinit cdreplay -q


##############################################
# Prompt / UI
##############################################
eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/zen.toml)"


##############################################
# Keybindings
##############################################
bindkey -e
bindkey '^[[A' history-beginning-search-backward   # Up
bindkey '^[[B' history-beginning-search-forward    # Down
bindkey '^p'  history-beginning-search-backward
bindkey '^n'  history-beginning-search-forward


##############################################
# History
##############################################
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=200000
export SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory sharehistory
setopt hist_ignore_space hist_ignore_all_dups hist_save_no_dups hist_ignore_dups hist_find_no_dups


##############################################
# Aliases
##############################################
alias n='nvim'

# Better ls aliases
alias ls='ls --color=auto'
alias la='ls -lAh --group-directories-first'
alias ll='ls -lh --group-directories-first'
alias l='ls -Ah --group-directories-first'

# Better cd
setopt AUTO_CD
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'   # previous dir


##############################################
# Functions
##############################################
# Simple: mkdir -p + cd
take() { mkdir -p -- "$1" && cd -- "$1"; }
# Tab-complete like `cd`
compdef _directories take


##############################################
# Shell integrations
##############################################
# Use fzf KEY BINDINGS only (avoid fzf's completion since fzf-tab handles it)
[[ -r /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh

# zoxide (using `cd` as the command per your config)
eval "$(zoxide init --cmd cd zsh)"

# Configure mise
eval "$(~/.local/bin/mise activate zsh)"

. "$HOME/.local/share/../bin/env"

# Configure Android SDK
export ANDROID_HOME=$HOME/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Patching electron apps problems
alias cursor='cursor --use-gl=egl'
