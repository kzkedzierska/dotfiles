# .bash_profile

if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

# Welcome cow :)
welcome_msg="Welcome back Kasia! \n\nIt's $(date '+%H:%M on %A, %B %d, %Y')"
wisdom_msg="Today's wisdom:\n $(fortune -s wisdom)"

bold=$(tput bold)
normal=$(tput sgr0)
quote="'A little more ${bold}PERSISETENCE${normal}, a little more ${bold}EFFORT${normal}, and what seemed hopeless ${bold}failure${normal} may turn to glorious ${bold}success${normal}.' - Albert Hubbard"
quote="'A little more PERSISETENCE, a little more EFFORT, and what seemed hopeless failure may turn to glorious success.' - Albert Hubbard"

echo -e "${welcome_msg}\n\n${quote}" | 
  cowsay -W 45 -f "$(cowsay -l | tail -n+2 | sed 's/ /\n/g' | shuf | head -n1)" | 
    lolcat -F 0.01


# ngschool_days="$(expr $(date --date 2022-09-15 '+%j') - $(date '+%j'))"
# ngsymposium_days="$(expr $(date --date 2022-09-23 '+%j') - $(date '+%j'))"

# echo -e "NGSchool2022 starts in  ${ngschool_days} days!" |
#   toilet -f term -F border --metal

# echo "NGSymposium2022 will be in ${ngsymposium_days} days!" | 
#   toilet -f term -F border --gay

# submission_date=`echo $(($(date --utc --date 2023-04-21 '+%s')/86400))`
# today=`echo $(($(date --utc '+%s')/86400))`
# submission_days=`expr ${submission_date} - ${today}`


# echo "Days left to submission deadline:  ${submission_days}" |
#   toilet -f term -F border --metal




