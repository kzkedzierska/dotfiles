# .bash_profile

if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

# Welcome cow :)
welcome_msg="Welcome back Kasia! \n\nIt's $(date '+%H:%M on %A, %B %d, %Y')"
wisdom_msg="Today's wisdom:\n $(fortune -s wisdom)"

bold=$(tput bold)
normal=$(tput sgr0)

# echo -e "${welcome_msg}\n\n${quote}" | 
echo -e "${welcome_msg}\n" |
  cowsay -W 45 -f "$(cowsay -l | tail -n+2 | sed 's/ /\n/g' | shuf | head -n1)" | 
    lolcat -F 0.01



