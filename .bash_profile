# Source .bashrc if it exists
if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi

# uv writes its PATH setup here; source it if present
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
