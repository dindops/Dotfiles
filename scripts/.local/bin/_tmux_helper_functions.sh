#!/usr/bin/env bash
switch_to() {
    if [[ -z $TMUX ]]; then
        tmux attach-session -t $1
    else
        is_popup_session && tmux detach-client
        tmux switch-client -t $1
    fi
}

has_session() {
    tmux list-sessions | grep -q "^$1:"
}

hydrate() {
    if [ -f $2/.tmux-sessionizer ]; then
        tmux send-keys -t $1 "source $2/.tmux-sessionizer" c-M
    elif [ -f $HOME/.tmux-sessionizer ]; then
        tmux send-keys -t $1 "source $HOME/.tmux-sessionizer" c-M
    fi
}

is_popup_session() {
    current_session_name=$(tmux display-message -p -F "#{session_name}")
    if [[ ${current_session_name} == *_popup ]]; then
        return 0
    else
        return 1
    fi
}
