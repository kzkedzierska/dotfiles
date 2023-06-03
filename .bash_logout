# ~/.bash_logout: executed by bash(1) when login shell exits.

# Goodbye cow :)
echo -e "Bye bye Kasia!" | 
  cowsay -f "$(cowsay -l | tail -n+2 | sed 's/ /\n/g' | shuf | head -n1)" -W 45 | 
    lolcat -F 0.01


# when leaving the console clear the screen to increase privacy

if [ "$SHLVL" = 1 ]; then
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi

