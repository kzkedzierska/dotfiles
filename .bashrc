#!/usr/bin/env bash

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# user-local bins (uv, claude, ...) + Ubuntu's /usr/games, where cowsay/fortune/
# lolcat install. Set BEFORE the greeting runs so those tools resolve.
export PATH="/usr/games:$HOME/.local/bin:$PATH"

# Path to the bash it configuration (cloned by bootstrap.sh into ~/github/bash-it)
export BASH_IT="$HOME/github/bash-it"

# Lock and Load a custom theme file.
# Leave empty to disable theming.
# location "$BASH_IT"/themes/
export BASH_IT_THEME='bobby'

# Some themes can show whether `sudo` has a current token or not.
# Set `$THEME_CHECK_SUDO` to `true` to check every prompt:
#THEME_CHECK_SUDO='true'

# (Advanced): Change this to the name of your remote repo if you
# cloned bash-it with a remote other than origin such as `bash-it`.
# export BASH_IT_REMOTE='bash-it'

# (Advanced): Change this to the name of the main development branch if
# you renamed it or if it was changed for some reason
# export BASH_IT_DEVELOPMENT_BRANCH='master'

# Your place for hosting Git repos. I use this for private repos.
export GIT_HOSTING='git@github.com'

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

# Theme clock settings — must be set BEFORE loading bash-it to take effect.
export THEME_CLOCK_FORMAT="%H:%M:%S"
export THEME_SHOW_CLOCK_CHAR=false

# Load Bash It
source "${BASH_IT}"/bash_it.sh

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

# Fix for lolcat in screen
if [ "$TERM" = "screen" ] || [ "$TERM" = "screen-256color" ]; then
  alias lolcat='COLORTERM= lolcat'
fi

fancy_console_greeting() {
  # Displays a fancy greeting message in the console.
  #
  # (1) The function checks for required dependencies and prompts to install
  # them if missing.
  # (2) Then, it composes a welcome message that includes the current date
  # and a fortune snippet.
  # (3) The message is then displayed using either cowsay or ponysay, randomly
  # chosen, with color effects applied by lolcat.

  # Usage:
  #   fancy_console_greeting [--verbose/-v]
  #
  # Options:
  #   --verbose/-v   Enable verbose mode.

  # Constants
  local DEPENDENCIES=(cowsay fortune lolcat)
  local OPTIONAL_DEPENDENCY="ponysay"

  # Default settings
  local verbose=false

  # Parse arguments
  for arg in "$@"; do
    case $arg in
      --verbose | -v)
        verbose=true
        shift
        ;;
      *)
        echo "Unknown option: $arg"
        return 1
        ;;
    esac
  done

  # Local variables
  local missing_deps=()
  local dep
  local current_date
  local fortune_msg
  local message
  local cow_file

  # Check for missing dependencies
  for dep in "${DEPENDENCIES[@]}"; do
    if ! command -v "${dep}" &>/dev/null; then
      missing_deps+=("${dep}")
    fi
  done

  # If there are any dependencies to install, print a message and exit
  if [[ ${#missing_deps[@]} -gt 0 ]]; then
    echo "To use fancy_console_greeting, you need to install the following " \
      "dependencies: ${missing_deps[*]}"
    return 1
  fi

  # Compose the message
  current_date=$(date '+%H:%M on %A, %B %d, %Y')
  fortune_msg=$(fortune -s wisdom)
  message="Welcome!\n\n"
  message+="It's ${current_date}.\n\n"
  message+="Today's wisdom:\n"
  message+="${fortune_msg}"

  # Randomly choose between cowsay and ponysay (if available)
  if command -v "${OPTIONAL_DEPENDENCY}" &>/dev/null && ((RANDOM % 2 == 1)); then
    # Use ponysay
    if [ "$verbose" = true ]; then
      echo -e "${message}" | ponysay --compact
    else
      echo -e "${message}" | ponysay --compact 2>/dev/null
    fi
  else
    # Use cowsay (either ponysay not available, or randomly chosen)
    cow_file=$(cowsay -l | tail -n +2 | tr ' ' '\n' | shuf | head -n 1)
    echo -e "${message}" | cowsay -f "${cow_file}" -W 45 | lolcat -F 0.01
  fi
}

export LANG=en_US.UTF-8
fancy_console_greeting

# unalias tree if it's aliased and a real tree binary exists
if [[ $(type -t tree) == "alias" ]] && command -v tree 2>/dev/null | grep -q "^/.*/tree$"; then
  unalias tree
fi
