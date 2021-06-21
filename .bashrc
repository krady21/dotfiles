# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=120000

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# Automatically fix directory name typos when changing directory
shopt -s cdspell

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export GIT_PS1_SHOWDIRTYSTATE=1
export PS1='\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[01;33m\]\w\[\033[00m\]\[\033[01;34m\]$(__git_ps1 " (%s)")\[\033[00m\] \n\\$ \[$(tput sgr0)\]'

export VISUAL=nvim
export EDITOR="$VISUAL"

export LESSHISTFILE=-

export FZF_DEFAULT_COMMAND='fd --type f  --follow --no-ignore'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export RIPGREP_CONFIG_PATH=~/.config/rg/ripgreprc

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export GCC_ARM_FOLDER=/home/boco/gcc-arm-none-eabi-9-2020-q2-update/bin

[ -f "/home/boco/.ghcup/env" ] && source "/home/boco/.ghcup/env"

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'

alias vi='nvim'
alias vim='nvim'
alias open='xdg-open'
