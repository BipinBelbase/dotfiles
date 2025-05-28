#############################
# Powerlevel10k Instant Prompt
#############################
# Suppress warnings by setting instant prompt to quiet (this avoids early console output issues):

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
echo "......"
# Set VI mode (this must be early)
set -o vi

# Load Powerlevel10k instant prompt if the file exists.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#############################
# Oh My Zsh Configuration
#############################
# Set the path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"


# Declare plugins to load. (This must come before sourcing Oh My Zsh.)
plugins=(
  zsh-vi-mode
  git
  macos
  python
)

# Source Oh My Zsh (this will load plugins, themes, etc.)
source $ZSH/oh-my-zsh.sh

# Wrapper function to update Brewfile after brew install/uninstall
function brew() {
  # Run the real brew command with all arguments
  command brew "$@"

  # Check if the command was install, uninstall, or remove
  if [[ "$1" == "install" || "$1" == "uninstall" || "$1" == "remove" ]]; then
    echo "Updating Brewfile..."
    brew bundle dump --file=~/dotfiles/homebrew/Brewfile --force
  fi
}
#############################
# User Customizations & Aliases
#############################
# quick directory jumping
# ——————————————————————————————


function nvim() {
  :
  echo "Please vim command"
}

# Detect OS and alias vim accordingly
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  alias vim='/usr/bin/nvim'       # Linux typical path
elif [[ "$OSTYPE" == "darwin"* ]]; then
  alias vim='/opt/homebrew/bin/nvim'  # macOS Homebrew path
fi
alias ..='cd ..'
alias python='python3'
alias reloadtm='tmux source-file ~/.tmux.conf'
alias lg='lazygit'
alias c='clear'
alias update='brew update && brew upgrade'
# ——————————————————————————————
# poweroff, reboot, sleep with one word
# ——————————————————————————————
alias poweroff='sudo shutdown -h now'       
alias reboot='sudo shutdown -r now'         
alias sleepnow='pmset sleepnow'

# show battery & charging status
alias battery='pmset -g batt'                  
#below is important
alias ls='eza --icons'
alias ll='eza -lah --icons && eza -ldh . ..'
alias cat='bat'
alias find='fd'
alias apple='neofetch'
alias hp='navi'

# This alias lets you SSH to your "fareast" server (ensure SSH keys are set up for passwordless login if desired)
alias linux="ssh fareast"
alias reload="source ~/.zshrc"
extract () {
     if [ -f $1 ] ; then
         case $1 in
             *.tar.bz2)   tar xjf $1        ;;
             *.tar.gz)    tar xzf $1     ;;
             *.bz2)       bunzip2 $1       ;;
             *.rar)       rar x $1     ;;
             *.gz)        gunzip $1     ;;
             *.tar)       tar xf $1        ;;
             *.tbz2)      tar xjf $1      ;;
             *.tgz)       tar xzf $1       ;;
             *.zip)       unzip $1     ;;
             *.Z)         uncompress $1  ;;
             *.7z)        7z x $1    ;;
             *)           echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

alias back='cd -'

unalias fzd 2>/dev/null
alias  q="exit"
#below is in the testing

fcd() {
  local dir
  dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
}
fzf(){
  if command -v fd &>/dev/null; then
    fd --type f --hidden --follow --exclude .git '' | command fzf "$@"
  else
    find . -path '*/\.*' -prune -o -type f -print 2>/dev/null | command fzf "$@"
  fi
}

fzo() {
  local file
  file=$(find ~ -type f 2>/dev/null | fzf)
  if [[ -n $file ]]; then
    cd "$(dirname "$file")"
    vim "$(basename "$file")"
  fi
}


#good
tm() {
  local default_name="bipinbelbase"
  local session_name="${1:-$default_name}"

  if ! command -v tmux &>/dev/null; then
    echo "❌ tmux is not installed!"
    return 1
  fi

  if [ -z "$TMUX" ]; then
    # Outside tmux: Start a new tmux session (interactive)
    echo "🚀 Launching tmux session: $session_name"
    tmux new -s "$session_name"
  else
    # Inside tmux: Create a new session in background
    if tmux has-session -t "$session_name" 2>/dev/null; then
      echo "⚠️ Session '$session_name' already exists. Switching to it..."
      tmux switch-client -t "$session_name"
    else
      echo "✨ Creating new tmux session: $session_name"
      tmux new-session -d -s "$session_name" && echo "✅ Created session: $session_name"
      tmux switch-client -t "$session_name"
    fi
  fi
}

alias tma='tmux -a'
alias tas='tmux attach -t'
alias tks='tmux kill-session -t'
alias tksa='tmux kill-server'
alias trs='tmux rename-session -t'
alias tls='tmux ls'
#############################
# Additional Tools: Powerlevel10k & Plugins
#############################
# Load Powerlevel10k theme (installed via Homebrew)
source "$(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fd --type f'  # if you have fd installed
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d'

# Autojump
[[ -f /opt/homebrew/etc/profile.d/autojump.sh ]] && \
  source /opt/homebrew/etc/profile.d/autojump.sh
# Load syntax highlighting and autosuggestions (also from Homebrew)
source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

#############################
# #############################
# Load Powerlevel10k Custom Config (if available)
#############################
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
#just for fun
#
# Add personal bin to PATH if it exists
if [[ -d "$HOME/.local/bin" ]]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

bindkey -s '^F' 'tmux-sessionizer\n'
# Define a function named "ff"
ff() {
    if [ -n "$TMUX" ]; then
        # Inside tmux
        tmux new-window "$HOME/.local/bin/tmux-sessionizer"
    else
        # Outside tmux
        "$HOME/.local/bin/tmux-sessionizer"
    fi
}

# ───────────────────────────────────────────────────────
# Bind Ctrl+F to your tmux‑sessionizer script via a ZLE widget
# ───────────────────────────────────────────────────────
# 1) Define the widget function (call the right filename)
tmux_sessionizer_widget() {
  BUFFER=""                       # clear any partially typed command
  zle -M ""                       # clear any status/message
  ~/.local/bin/tmux-sessionizer  # run your script
  zle reset-prompt                # redraw prompt after it exits
}
# 2) Register it as a ZLE widget
zle -N tmux_sessionizer_widget
# 3) Bind Ctrl+F (ASCII ^F) to that widget
bindkey '^F' tmux_sessionizer_widget
