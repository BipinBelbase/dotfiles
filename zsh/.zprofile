eval "$(/opt/homebrew/bin/brew shellenv)"
bindkey -s ^f "tmux-sessionizer\n"

if [[ -t 1 ]] && [[ $- == *i* ]] && command -v tmux &>/dev/null && [[ -z "$TMUX" ]]; then
  tmux attach -t main || tmux new -s main
fi
