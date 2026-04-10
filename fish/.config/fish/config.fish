function fish_greeting
    fortune -a
end

if status is-interactive
    starship init fish | source
    pyenv init - fish | source
    goenv init - fish | source

    fish_default_key_bindings

    # fzf.fish configs
    fzf_configure_bindings --directory=\cf --variables=\e\cv
    set fzf_directory_opts --bind "ctrl-o:execute(nvim {} &> /dev/tty)"
    set fzf_fd_opts --hidden --exclude=.git

    direnv hook fish | source
end

# Aliases:
alias bud='libreoffice $HOME/Documents/Personal/budget.ods'
alias f='nvim (fzf --preview "bat --color=always {}")'
