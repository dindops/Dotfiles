function vp --description "Pick a taskwarrior project with fzf and open in vit"
    set project (task projects rc.verbose=nothing 2>/dev/null \
        | tail -n +2 \
        | grep -v '^-' \
        | grep -v '^\s*$' \
        | grep -v 'projects' \
        | awk '{print $1}' \
        | fzf --prompt="project> " --height=40% --reverse)

    if test -n "$project"
        vit project:$project
    end
end
