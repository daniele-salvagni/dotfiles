#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# Execute gems without typing out the full location
PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"

# Includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

alias please='sudo $(fc -ln -1)'
