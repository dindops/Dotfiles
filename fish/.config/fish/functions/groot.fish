function groot --description "cd to the root of the current git repository"
    set -l root (git rev-parse --show-toplevel 2>/dev/null) || return 0
    cd $root
end
