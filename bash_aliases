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

# work server connections
alias rescomp='ssh jgy292@rescomp2.well.ox.ac.uk'
alias rotation1='sudo sshfs jgy292@rescomp.well.ox.ac.uk:/well/wedge/jgy292/ /mnt/rotation1/ -o IdentityFile=/home/kzkedzierska/.ssh/rescomp -o reconnect -C -o allow_other'
alias ucec='sudo sshfs jgy292@rescomp.well.ox.ac.uk:/well/lewis/projects/kasia/ /mnt/ucec/ -o IdentityFile=/home/kzkedzierska/.ssh/rescomp -o reconnect -C -o allow_other'
alias cna='sudo sshfs jgy292@rescomp.well.ox.ac.uk:/gpfs2/well/church/jgy292/ /mnt/rotation2 -o IdentityFile=/home/kzkedzierska/.ssh/rescomp -o reconnect -C -o allow_other'

# ask permission whenever rm used and tell me what I deleted...
alias rm='rm -i -v'

# say what is being done
alias cp='cp -v'

# picard
alias picard='java -jar ~/Packages/picard.jar'

# xclip
alias xclip="xclip -selection c"

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

