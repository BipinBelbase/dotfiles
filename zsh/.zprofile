eval "$(/opt/homebrew/bin/brew shellenv)"
bindkey -s ^f "tmux-sessionizer\n"

VIM="nvim"

catr() {
    tail -n "+$1" $3 | head -n "$(($2 - $1 + 1))"
}

if [[ -t 1 ]] && [[ $- == *i* ]] && command -v tmux &>/dev/null && [[ -z "$TMUX" ]]; then
  tmux attach -t "$USER" || tmux new -s "$USER"
fi
