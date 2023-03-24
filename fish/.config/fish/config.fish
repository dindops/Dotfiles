if status is-interactive
    # Commands to run in interactive sessions can go here
end
function fish_greeting
    fortune -a
end
starship init fish | source
pyenv init - | source

fish_default_key_bindings

# fzf.fish configs
fzf_configure_bindings --directory=\cf --variables=\e\cv
set fzf_directory_opts --bind "ctrl-o:execute(vim {} &> /dev/tty)"

# Aliases:
alias proj='cd $HOME/Documents/Projects'
alias wiki='vim $HOME/vimwiki/index.md'
alias gwiki='cd $HOME/vimwiki/'
alias bud='libreoffice $HOME/Documents/Personal/budget.ods'
alias vim='nvim'
alias vi='vim'
alias f='nvim (fzf --preview "bat --color=always {}")'
