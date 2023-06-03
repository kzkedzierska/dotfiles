#!/usr/bin/env bash

# Path to the bash it configuration
export BASH_IT="/home/kzkedzierska/.bash_it"

# Lock and Load a custom theme file
# location /.bash_it/themes/
export BASH_IT_THEME='bobby'

# (Advanced): Change this to the name of your remote repo if you
# cloned bash-it with a remote other than origin such as `bash-it`.
# export BASH_IT_REMOTE='bash-it'

# Your place for hosting Git repos. I use this for private repos.
export GIT_HOSTING='git@git.domain.com'

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

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/kzkedzierska/.local/share/r-miniconda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/kzkedzierska/.local/share/r-miniconda/etc/profile.d/conda.sh" ]; then
        . "/home/kzkedzierska/.local/share/r-miniconda/etc/profile.d/conda.sh"
    else
        export PATH="/home/kzkedzierska/.local/share/r-miniconda/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
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


echo -e "Welcome! \n\nIt's $(date '+%H:%M on %A, %B %d, %Y').\n\nHere's some wisdom for you:\n $(fortune -s wisdom)" |
  cowsay -f "$(cowsay -l | tail -n+2 | sed 's/ /\n/g' | shuf | head -n1)" -W 45 |
    lolcat -F 0.01
