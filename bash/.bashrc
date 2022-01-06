# Prompt
export PS1="\[$(tput bold)\]\[$(tput setaf 7)\]\w\[$(tput setaf 2)\]> \[$(tput sgr0)\]"
# prompt: [user@host path]$ and colours:
# export PS1="\[$(tput bold)\]\[$(tput setaf 3)\][\[$(tput setaf 7)\]\u\[$(tput setaf 0)\]@\[$(tput setaf 0)\]\h \[$(tput setaf 4)\]\W\[$(tput setaf 3)\]]\[$(tput setaf 7)\]\\$ \[$(tput sgr0)\]"

set -o emacs

#Blocking pesky Ctrl+S action
stty -ixon

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

HISTIGNORE="$HISTIGNORE:jrnl *"
# save history with dates of command execution
export HISTTIMEFORMAT="%d/%m/%y %T "
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize


# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -la'
#alias rm='rm -i'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

shopt -s autocd # Allows you to cd into directory merely by typing the directory name.

export BROWSER=firefox
export BROWSERCLI=lynx

HISTIGNORE="$HISTIGNORE:jrnl *"
export VISUAL=vim
export EDITOR="$VISUAL"
force_color_prompt=yes
setxkbmap pl
export MAN_POSIXLY_CORRECT=1

complete -C /usr/bin/terraform terraform
