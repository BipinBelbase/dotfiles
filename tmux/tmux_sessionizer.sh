#!/usr/bin/env bash

selected=$(find "$HOME" \
    -type d -name '.git' -prune -o \
    -type d -name 'Library' -prune -o \
    -type d -name '.local' -prune -o \
    -type d -name 'raycast' -prune -o \
    -type d -name '.npm' -prune -o \
    -type d -name '.cache' -prune -o \
    -type d -name '.DS_Store' -prune -o \
    -type d -name '.oh-my-zsh' -prune -o \
    -type d -print | fzf) || exit 0

selected_name=$(basename "$selected" | tr . _)

if [[ -z $TMUX ]]; then
    # Outside tmux: attach or create
    tmux new-session -A -s "$selected_name" -c "$selected"
else
    # Inside tmux: create the session if not exists
    if ! tmux has-session -t="$selected_name" 2>/dev/null; then
        tmux new-session -ds "$selected_name" -c "$selected"
    fi
    # Open a new window and attach to the session using nested tmux
    tmux new-window -n "$selected_name" "tmux attach-session -t $selected_name"
fi
