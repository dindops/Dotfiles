#!/usr/bin/env bash
source _tmux_helper_functions.sh

# Usage: task jump <task_id>
# 1. Extract the line & file path from task's description
# 2. Launch Tmux, open nvim at that line in that file

task_id="$1"
if [ -z "$task_id" ]; then
  echo "Usage: task jump <task_id>"
  exit 1
fi

desc=$(task _get "$task_id".description)
project=$(task _get "$task_id".project)

nvimline=$(echo "$desc" | grep -o 'nvimline:[^ ]*')
line=$(echo "$nvimline" | cut -d':' -f 2)
filepath=$(echo "$nvimline" | cut -d':' -f 3-)

if ! has_session $project; then
    tmux new-session -ds $project "nvim +${line} ${filepath}"
else
    tmux new-window -t $project "nvim +${line} ${filepath}"
fi

switch_to $project
