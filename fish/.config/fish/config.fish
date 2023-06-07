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
set fzf_directory_opts --bind "ctrl-o:execute(nvim {} &> /dev/tty)"
set fzf_fd_opts --hidden --exclude=.git

# Aliases:
alias bud='libreoffice $HOME/Documents/Personal/budget.ods'
alias f='nvim (fzf --preview "bat --color=always {}")'
