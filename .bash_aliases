# ~/.bash_aliases: executed by bashrc 

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'

# ask permission whenever rm used and tell me what I deleted...
alias rm='rm -i -v'

# say what is being done
alias cp='cp -v'

# Invert colors with sunny weather
alias invert_colors='xcalib -invert -alter'

# xclip
alias xclip="xclip -selection c"

# conda
alias run_conda='eval "$(/home/kzkedzierska/miniconda3/bin/conda shell.bash hook)"'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
# alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# WCHG
alias rescomp='. ~/.secret && sshpass -p "${REMOTE_PASSWORD}" ssh amp428@cluster2.bmrc.ox.ac.uk; unset REMOTE_PASSWORD'

alias carbon-jupyter='ssh -N -f -L 9999:localhost:9000 kzkedzierska@129.67.45.246'

alias rescomp_data='sudo sshfs amp428@rescomp2.well.ox.ac.uk:data/ /mnt/rescomp/ -o IdentityFile=/home/kzkedzierska/.ssh/rescomp -o reconnect -C -o allow_other'
alias carbon-data='sudo sshfs kzkedzierska@129.67.45.246:/mnt/data/ /mnt/data/ -o IdentityFile=/home/kzkedzierska/.ssh/carbon -o reconnect -C -o allow_other'
alias carbon-home='sudo sshfs kzkedzierska@129.67.45.246: /mnt/carbon_home/ -o IdentityFile=/home/kzkedzierska/.ssh/carbon -o reconnect -C -o allow_other'

