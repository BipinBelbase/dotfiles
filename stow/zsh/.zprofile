if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi
bindkey -s ^f "tmux-sessionizer\n"

VIM="nvim"


if [[ -t 1 ]] && [[ $- == *i* ]] && command -v tmux &>/dev/null && [[ -z "$TMUX" ]]; then
  tmux attach -t "$USER" || tmux new -s "$USER"
fi
