#############################
# Powerlevel10k Instant Prompt
#############################
# Suppress warnings by setting instant prompt to quiet (this avoids early console output issues):
# this below is for the remembering 
# j <CR> = find the directory and open
# ff <CR> find dirctory and open new tmux session
# jo <CR> find fild and open in the vim

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
unalias gl 2>/dev/null
alias lg='lazygit'
alias c='clear'
alias update='brew update && brew upgrade'
alias poweroff='sudo shutdown -h now'       
alias reboot='sudo shutdown -r now'         
alias sleepnow='pmset sleepnow'
alias battery='pmset -g batt'                  
alias ls='eza --icons'
alias ll='eza -lah --icons && eza -ldh . ..'
alias cat='bat'
alias find='fd'
alias apple='fastfetch'
alias help='navi'
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
alias yabaireload='yabai --restart-service && skhd --restart-service '
alias yabaistart='yabai --start-service'
alias yabaistop='yabai --stop-service'
alias yabaiload='yabai --load-sa'
#make the directory then cd into it 
function mkd() {
	mkdir -p "$1"
	cd "$1"
}
function cd() {
	# Try a normal cd
	builtin cd "$@" 2> /dev/null
	if [ $? = 0 ]; then
		# If we get here cd was successful so do a ls
		ls
	else
		# If we get here, cd was not successful
		if [ -f "$1" ]; then
			# If there is a file there, try and open it in vim
			# ToDo: smarter open so it will open in zathura if it's a pdf for
			# example
			$EDITOR "$1"
		else
			# Otherwise fail clearly
			echo "Can't cd"
		fi
	fi
	#updatePath
}

alias process='glances'

size() {
  if [[ -z "$1" ]]; then
    echo "Usage: size <file_or_directory>"
    return 1
  fi

  local target="$1"

  if [[ ! -e "$target" ]]; then
    echo "❌ '$target' does not exist"
    return 1
  fi

  du -sh -- "$target"
}

catr() {
    tail -n "+$1" $3 | head -n "$(($2 - $1 + 1))"
}

jo() {
  local dir
  dir=$(
    fd --type f --hidden --exclude .git --exclude .tmux --exclude .local --exclude .oh-my-zsh --exclude .Trash --exclude Applications --exclude Library --exclude .cache --exclude  .npm --exclude  Movies --exclude  Music '' "$HOME" 2> /dev/null \
    | fzf --height 60% --layout=reverse --border
  ) && vim "$dir"
}

fzd() {
  local dir
  dir=$(
    fd --type d --hidden --exclude .git --exclude .tmux --exclude .local --exclude .oh-my-zsh --exclude .Trash --exclude Applications --exclude Library --exclude .cache --exclude  .npm --exclude  Movies --exclude  Music '' "$HOME" 2> /dev/null \
    | fzf --height 60% --layout=reverse --border
  ) && cd "$dir"
}
j() {
  if [ "$#" -eq 0 ]; then
      fzd
  else
    local target
    target=$(zoxide query "$*")
    if [ $? -eq 0 ]; then
      cd "$target"
    else
      cd "$(zoxide query -l | fzd)"
    fi
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

alias tma='tmux a'
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

if [[ -d "$HOME/.cargo/bin" ]]; then
  export PATH="$HOME/.cargo/bin:$PATH"
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
bindkey '^Y' autosuggest-accept

# Enable menu-style completions
zstyle ':completion:*' menu select
eval "$(zoxide init zsh)"





export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/bipinbelbase/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions
