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

# ssh peyote2 alias
alias sshpeyote2='ssh -i /home/kkedzierska/.ssh/peyote.pub kkedzierska@192.168.3.227'
alias openvpnp2='sudo openvpn --cd /etc/openvpn/ --config kkedzierska.conf --verb 4'
alias p2forward='sudo ip route add 192.168.1.1 dev wlp1s0'
alias p2R='ssh -L 8787:10.1.2.143:8787 kkedzierska@192.168.3.227'

# mounting remote folders
alias isihome='sudo sshfs kkedzierska@192.168.3.227:/mnt/isihome/kkedzierska/ /mnt/isiHome/ -o IdentityFile=/home/kkedzierska/.ssh/peyote -o reconnect -C -o workaround=all -o allow_other'
alias peyote2='sudo sshfs kkedzierska@192.168.3.227:/home/kkedzierska/ /mnt/peyote2/ -o IdentityFile=/home/kkedzierska/.ssh/peyote -o reconnect -C -o workaround=all -o allow_other'
alias umisihome='sudo fusermount -u /mnt/isiHome'
alias umpeyote2='sudo fusermount -u /mnt/peyote'

# ssh UVA
alias sshzeus='ssh -i /home/kkedzierska/.ssh/id_zeus kzk5f@zeus.cphg.virginia.edu'
alias scratch='sudo sshfs kzk5f@zeus.cphg.virginia.edu:/m/cphg-RLscratch/cphg-RLscratch/kzk5f/ /mnt/scratch/ -o IdentityFile=/home/kkedzierska/.ssh/id_zeus -o reconnect -C -o workaround=all -o allow_other'

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

