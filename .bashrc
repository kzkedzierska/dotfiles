#!/usr/bin/env bash

# ensure user-local bins (uv, claude, ...) are on PATH
export PATH="$HOME/.local/bin:$PATH"

# Path to the bash it configuration (cloned by bootstrap.sh into ~/github/bash-it)
export BASH_IT="$HOME/github/bash-it"

# Lock and Load a custom theme file
# location /.bash_it/themes/
export BASH_IT_THEME='bobby'

# Don't check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.
export IRC_CLIENT='irssi'

# Set this to the command you use for todo.txt-cli
export TODO="t"

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true

# Set Xterm/screen/Tmux title with only a short hostname.
# Uncomment this (or set SHORT_HOSTNAME to something else),
# Will otherwise fall back on $HOSTNAME.
#export SHORT_HOSTNAME=$(hostname -s)

# Set Xterm/screen/Tmux title with only a short username.
# Uncomment this (or set SHORT_USER to something else),
# Will otherwise fall back on $USER.
#export SHORT_USER=${USER:0:8}

# Set Xterm/screen/Tmux title with shortened command and directory.
# Uncomment this to set.
#export SHORT_TERM_LINE=true

# Set vcprompt executable path for scm advance info in prompt (demula theme)
# https://github.com/djl/vcprompt
#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

# (Advanced): Uncomment this to make Bash-it reload itself automatically
# after enabling or disabling aliases, plugins, and completions.
# export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1

# Uncomment this to make Bash-it create alias reload.
# export BASH_IT_RELOAD_LEGACY=1

# Load Bash It
source "$BASH_IT"/bash_it.sh

THEME_CLOCK_FORMAT="%H:%M:%S"
THEME_SHOW_CLOCK_CHAR=false

# ALIASES
if [ -f ~/.bash_aliases ]; then
  source ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable             
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile            
# sources /etc/bash.bashrc).                                                    
if ! shopt -oq posix; then                                                      
  if [ -f /usr/share/bash-completion/bash_completion ]; then                    
    . /usr/share/bash-completion/bash_completion                                
  elif [ -f /etc/bash_completion ]; then                                        
    . /etc/bash_completion                                                      
  fi                                                                            
fi

# add git completion
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# print cow saying a fortune
echo -e "Welcome! \n\nIt's $(date '+%H:%M on %A, %B %d, %Y').\n\nHere's some wisdom for you:\n $(fortune -s wisdom)" |
  cowsay -f "$(cowsay -l | tail -n+2 | sed 's/ /\n/g' | shuf | head -n1)" -W 45 |
    lolcat -F 0.01
