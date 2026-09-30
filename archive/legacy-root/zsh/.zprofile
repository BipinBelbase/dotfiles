eval "$(/opt/homebrew/bin/brew shellenv)"
bindkey -s ^f "tmux-sessionizer\n"

VIM="nvim"


if [[ -t 1 ]] && [[ $- == *i* ]] && command -v tmux &>/dev/null && [[ -z "$TMUX" ]]; then
  tmux attach -t "$USER" || tmux new -s "$USER"
fi
