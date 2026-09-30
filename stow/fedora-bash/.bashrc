# Fedora-specific Bash profile. Kept separate from stow/bash so Mac stays intact.

# Preserve Fedora's system defaults and user-defined startup snippets.
if [[ -r /etc/bashrc ]]; then
  source /etc/bashrc
elif [[ -r /etc/bash.bashrc ]]; then
  source /etc/bash.bashrc
fi

if [[ -d "$HOME/.bashrc.d" ]]; then
  for rc in "$HOME"/.bashrc.d/*.sh; do
    [[ -r "$rc" ]] && source "$rc"
  done
fi

case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

export EDITOR="${DOTFILES_EDITOR:-$(command -v nvim || command -v vim || command -v nano || printf vi)}"
export VISUAL="$EDITOR"

if [[ $- == *i* ]]; then
  set -o vi

  alias ..='cd ..'
  alias ...='cd ../..'
  alias c='clear'
  alias q='exit'
  alias python='python3'
  alias reload='source ~/.bashrc'
  if command -v dnf >/dev/null 2>&1; then
    alias update='sudo dnf upgrade --refresh'
  elif command -v pacman >/dev/null 2>&1; then
    alias update='sudo pacman -Syu'
  elif command -v apt-get >/dev/null 2>&1; then
    alias update='sudo apt-get update && sudo apt-get upgrade'
  fi

  if command -v nvim >/dev/null 2>&1; then
    alias vim='nvim'
  fi
  if command -v tmux >/dev/null 2>&1; then
    alias reloadtm='tmux source-file ~/.tmux.conf'
    alias tma='tmux attach'
    alias tls='tmux ls'
  fi
  if command -v lazygit >/dev/null 2>&1; then
    alias lg='lazygit'
  fi
  if command -v codex >/dev/null 2>&1; then
    alias ai='codex'
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

  if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init bash)"
    j() {
      local target
      target=$(zoxide query --interactive "$@") || return
      builtin cd -- "$target"
    }
  fi

  if command -v tmux-sessionizer >/dev/null 2>&1; then
    ff() {
      if [[ -n "${TMUX:-}" ]]; then
        tmux new-window tmux-sessionizer
      else
        tmux-sessionizer
      fi
    }
  fi

  if command -v tmux >/dev/null 2>&1; then
    tm() {
      local session_name=${1:-bipinbelbase}
      if [[ -n "${TMUX:-}" ]]; then
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

  if command -v fzf >/dev/null 2>&1 && [[ -r /usr/share/fzf/shell/key-bindings.bash ]]; then
    source /usr/share/fzf/shell/key-bindings.bash
  fi
fi
