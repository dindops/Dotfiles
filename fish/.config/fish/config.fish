if status is-interactive
    # Commands to run in interactive sessions can go here
end
function fish_greeting
    fortune -a
end
starship init fish | source
pyenv init - | source

fish_vi_key_bindings

# Aliases:
alias proj='cd $HOME/Documents/Projects'
alias wiki='vim $HOME/vimwiki/index.md'
alias gwiki='cd $HOME/vimwiki/'
alias bud='libreoffice $HOME/Documents/Personal/budget.ods'
