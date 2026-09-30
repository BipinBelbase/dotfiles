# Linux Zsh profile. The macOS .zshrc remains separate and unchanged.

[[ -r /etc/zshrc ]] && source /etc/zshrc
[[ -r /etc/zsh/zshrc ]] && source /etc/zsh/zshrc

export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.local/opt/nvim/bin:$PATH"
export EDITOR="${DOTFILES_EDITOR:-$(command -v nvim || command -v vim || command -v nano || printf vi)}"
export VISUAL="$EDITOR"

setopt AUTO_CD INTERACTIVE_COMMENTS
bindkey -v

if [[ -r "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]]; then
  export ZSH="$HOME/.oh-my-zsh"
  ZSH_THEME="powerlevel10k/powerlevel10k"
  plugins=(git python sudo)
  source "$ZSH/oh-my-zsh.sh"
fi

for plugin in \
  /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh; do
  [[ -r "$plugin" ]] && source "$plugin"
done

[[ -r "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

alias ..='cd ..'
alias ...='cd ../..'
alias c='clear'
alias q='exit'
alias python='python3'
alias reload='source ~/.zshrc'

if command -v dnf >/dev/null 2>&1; then
  alias update='sudo dnf upgrade --refresh'
elif command -v pacman >/dev/null 2>&1; then
  alias update='sudo pacman -Syu'
elif command -v apt-get >/dev/null 2>&1; then
  alias update='sudo apt-get update && sudo apt-get upgrade'
fi

if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons=auto'
  alias ll='eza -lah --icons=auto'
else
  alias ll='ls -lah'
fi

if command -v bat >/dev/null 2>&1; then
  alias cat='bat'
elif command -v batcat >/dev/null 2>&1; then
  alias cat='batcat'
fi

if command -v fd >/dev/null 2>&1; then
  alias find='fd'
elif command -v fdfind >/dev/null 2>&1; then
  alias find='fdfind'
fi

if command -v nvim >/dev/null 2>&1; then
  alias vim='nvim'
fi
if command -v tmux >/dev/null 2>&1; then
  alias reloadtm='tmux source-file ~/.tmux.conf'
  alias tma='tmux attach'
  alias tls='tmux ls'
  tm() {
    local session_name=${1:-bipinbelbase}
    if [[ -n "$TMUX" ]]; then
      if tmux has-session -t "$session_name" 2>/dev/null; then
        tmux switch-client -t "$session_name"
      else
        tmux new-session -d -s "$session_name" && tmux switch-client -t "$session_name"
      fi
    else
      tmux new-session -A -s "$session_name"
    fi
  }
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

if command -v fzf >/dev/null 2>&1; then
  for fzf_init in /usr/share/fzf/key-bindings.zsh /usr/share/fzf/shell/key-bindings.zsh /usr/share/doc/fzf/examples/key-bindings.zsh; do
    [[ -r "$fzf_init" ]] && source "$fzf_init" && break
  done
fi

if command -v tmux-sessionizer >/dev/null 2>&1; then
  tmux_sessionizer_widget() {
    BUFFER=''
    tmux-sessionizer
    zle reset-prompt
  }
  zle -N tmux_sessionizer_widget
  bindkey '^F' tmux_sessionizer_widget
  ff() {
    if [[ -n "$TMUX" ]]; then
      tmux new-window "$HOME/.local/bin/tmux-sessionizer"
    else
      tmux-sessionizer
    fi
  }
fi

if [[ -o interactive ]] && command -v tmux >/dev/null 2>&1 && [[ -z "$TMUX" ]]; then
  tmux attach -t "$USER" 2>/dev/null || tmux new-session -s "$USER"
fi
