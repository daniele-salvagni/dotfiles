#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# Execute gems without typing out the full location
PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"

# ~/.local/bin
PATH="$/home/dan/.local/bin:$PATH"

# Stack path for Haskell
PATH="/home/dan/.stack/snapshots/x86_64-linux/lts-5.5/7.10.3/bin:/home/dan/.stack/programs/x86_64-linux/ghc-7.10.3/bin:/home/dan/.gem/ruby/2.3.0/bin:/home/dan/.gem/ruby/2.3.0/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/lib/jvm/default/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:$PATH"

# Includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# Add sudo to the previous command
alias please='sudo $(fc -ln -1)'
