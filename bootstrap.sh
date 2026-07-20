#!/usr/bin/env bash

# ======================================================================================================================
# bootstrap.sh - provision a fresh Ubuntu node with my shell config + core CLIs.
#
# Usage: bootstrap.sh [-vqh] [--no-auth] [--no-tools] [--version]
#
# Installs deps and CLIs (git, gh, uv, claude), clones my dotfiles / bash-it fork /
# instructing_agents into ~/github, symlinks the configs into $HOME, and (unless
# --no-auth) launches the interactive GitHub and Claude Code login flows.
#
# Safe to re-run: every step is idempotent (skips work already done).
#
# OPTIONS:
#   --no-auth        Skip the interactive gh / claude login steps
#   --no-tools       Skip apt/gh/uv/claude installation (only clone + symlink)
#   --verbose, -v    Verbose mode (show debug logging)
#   --quiet, -q      Quiet mode (errors only)
#   --help, -h       Print this help and exit
#   --version        Print version and exit
#
# ENV OVERRIDES (optional):
#   DOTFILES_REPO, BASH_IT_REPO, AGENTS_REPO   override the git URLs
# ======================================================================================================================

set -Eeuo pipefail

# ---- config: edit these (or override via env) if you fork under a different account ----
DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/kzkedzierska/dotfiles.git}"
BASH_IT_REPO="${BASH_IT_REPO:-https://github.com/kzkedzierska/bash-it.git}"
AGENTS_REPO="${AGENTS_REPO:-https://github.com/kzkedzierska/instructing_agents.git}"
# ----------------------------------------------------------------------------------------

PROGRAM="bootstrap.sh"
VERSION="1.0"

GITHUB_DIR="$HOME/github"
DOTFILES_DIR="$GITHUB_DIR/dotfiles"
BASH_IT_DIR="$GITHUB_DIR/bash-it"
AGENTS_DIR="$GITHUB_DIR/instructing_agents"

# Defaults / state
LOG_LEVEL="normal"   # quiet | normal | verbose
DO_AUTH="true"
DO_TOOLS="true"
EXITCODE=0

# ---------------------------------------------------------------------------------------- logging
if [ -t 2 ] && [ -z "${NO_COLOR:-}" ]; then
  RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
  BLUE='\033[0;34m'; PURPLE='\033[0;35m'; GRAY='\033[0;90m'; NC='\033[0m'
else
  RED=''; GREEN=''; YELLOW=''; BLUE=''; PURPLE=''; GRAY=''; NC=''
fi

get_timestamp() { date '+%Y-%m-%d %H:%M:%S'; }

log_error()    { echo -e "${RED}[ERROR]${NC}    [$(get_timestamp)] $*" >&2; EXITCODE=$((EXITCODE + 1)); }
log_warn()     { [ "$LOG_LEVEL" != "quiet" ] && echo -e "${YELLOW}[WARN]${NC}     [$(get_timestamp)] $*" >&2 || true; }
log_info()     { [ "$LOG_LEVEL" != "quiet" ] && echo -e "${GREEN}[INFO]${NC}     [$(get_timestamp)] $*" >&2 || true; }
log_success()  { [ "$LOG_LEVEL" != "quiet" ] && echo -e "${GREEN}[SUCCESS]${NC}  [$(get_timestamp)] $*" >&2 || true; }
log_system()   { [ "$LOG_LEVEL" != "quiet" ] && echo -e "${BLUE}[SYSTEM]${NC}   [$(get_timestamp)] $*" >&2 || true; }
log_security() { [ "$LOG_LEVEL" != "quiet" ] && echo -e "${PURPLE}[SECURITY]${NC} [$(get_timestamp)] $*" >&2 || true; }
log_debug()    { [ "$LOG_LEVEL" = "verbose" ] && echo -e "${GRAY}[DEBUG]${NC}    [$(get_timestamp)] $*" >&2 || true; }

die() { log_error "$@"; exit 1; }

trap 'rc=$?; log_error "aborted at line ${LINENO} (exit ${rc})"; exit "${rc}"' ERR

usage() {
  echo -e "
${GREEN}Usage: ${PROGRAM} [OPTIONS]${NC}   (version ${VERSION})

Provision a fresh Ubuntu node: install core CLIs, clone repos into ~/github,
symlink dotfiles, and launch the GitHub + Claude Code login flows.

${YELLOW}OPTIONS:${NC}
    ${GREEN}--no-auth${NC}         Skip the interactive gh / claude login steps
    ${GREEN}--no-tools${NC}        Skip apt/gh/uv/claude installation (clone + symlink only)
    ${GREEN}--verbose, -v${NC}     Verbose mode (show debug logging)
    ${GREEN}--quiet, -q${NC}       Quiet mode (errors only)
    ${GREEN}--help, -h${NC}        Print this help and exit
    ${GREEN}--version${NC}         Print version and exit

${YELLOW}EXAMPLES:${NC}
    ${GRAY}${PROGRAM}${NC}                    # full setup incl. interactive logins
    ${GRAY}${PROGRAM} --no-auth${NC}          # set everything up, log in later
    ${GRAY}${PROGRAM} -v${NC}                 # verbose
"
}

version()        { echo -e "${GREEN}${PROGRAM} version ${VERSION}${NC}"; }
usage_and_exit() { usage; exit "${1:-0}"; }
arg_error()      { log_error "$*"; usage; exit 1; }

# ---------------------------------------------------------------------------------------- helpers
have() { command -v "$1" >/dev/null 2>&1; }

# Run a command interactively against the real terminal, even under `curl | bash`
# (where stdin is the pipe). Returns non-zero (without aborting) if no tty is available.
run_interactive() {
  if [ -e /dev/tty ] && [ -r /dev/tty ]; then
    "$@" </dev/tty
  else
    return 97
  fi
}

check_dependencies() {
  log_debug "checking base dependencies"
  have sudo || die "sudo is required but not found"
  have curl || have wget || die "need curl or wget to fetch installers"
  # git is bootstrapped by install_apt_deps; only hard-require it when tools are skipped
  if [ "$DO_TOOLS" = "false" ] && ! have git; then
    die "git not found and --no-tools was given; install git first"
  fi
  log_debug "dependency check passed"
}

# ---------------------------------------------------------------------------------------- steps
install_apt_deps() {
  log_system "installing apt dependencies"
  sudo apt-get update -qq
  sudo apt-get install -y -qq git curl cowsay fortune-mod lolcat >/dev/null
  log_success "apt dependencies installed (git curl cowsay fortune-mod lolcat)"
}

install_gh() {
  if have gh; then log_info "gh already installed ($(gh --version | head -1))"; return; fi
  log_system "installing gh (GitHub CLI)"
  sudo mkdir -p -m 755 /etc/apt/keyrings
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null
  sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
  sudo apt-get update -qq
  sudo apt-get install -y -qq gh >/dev/null
  log_success "gh installed"
}

install_uv() {
  if have uv; then log_info "uv already installed ($(uv --version))"; return; fi
  log_system "installing uv"
  curl -LsSf https://astral.sh/uv/install.sh | sh -s -- --no-modify-path
  hash -r
  have uv && log_success "uv installed ($(uv --version))" || log_warn "uv installed but not on PATH yet"
}

install_claude() {
  if have claude; then log_info "claude already installed"; return; fi
  log_system "installing claude code"
  curl -fsSL https://claude.ai/install.sh | bash
  hash -r
  have claude && log_success "claude installed" || log_warn "claude installed but not on PATH yet (check ~/.local/bin)"
}

clone_repos() {
  log_system "cloning repos into ${GITHUB_DIR}"
  mkdir -p "$GITHUB_DIR"
  local pairs=("$DOTFILES_DIR|$DOTFILES_REPO" "$BASH_IT_DIR|$BASH_IT_REPO" "$AGENTS_DIR|$AGENTS_REPO")
  for p in "${pairs[@]}"; do
    local dir="${p%%|*}" url="${p##*|}"
    if [ -d "$dir/.git" ]; then
      log_info "already cloned: $(basename "$dir")"
    else
      git clone --depth 1 "$url" "$dir" && log_success "cloned $(basename "$dir")"
    fi
  done
}

symlink_dotfiles() {
  log_system "symlinking dotfiles into \$HOME"
  local f src
  for f in .screenrc .bashrc .bash_profile .bash_aliases .inputrc .gitconfig .vimrc; do
    src="$DOTFILES_DIR/$f"
    if [ -f "$src" ]; then
      ln -sf "$src" "$HOME/$f"
      log_debug "linked ~/$f -> $src"
    fi
  done
  log_success "dotfiles symlinked"
}

symlink_agents() {
  log_system "symlinking agent instructions"
  mkdir -p "$HOME/.config" "$HOME/.claude"
  ln -sf "$AGENTS_DIR/AGENTS.md" "$HOME/.config/AGENTS.md"
  ln -sf "$HOME/.config/AGENTS.md" "$HOME/.claude/CLAUDE.md"
  log_success "AGENTS.md + CLAUDE.md linked to instructing_agents"
}

symlink_claude_settings() {
  log_system "symlinking claude settings (non-secret; auth stays per-node)"
  mkdir -p "$HOME/.claude"
  ln -sf "$DOTFILES_DIR/claude/settings.json" "$HOME/.claude/settings.json"
  log_success "~/.claude/settings.json linked"
}

run_bash_it() {
  if [ ! -x "$BASH_IT_DIR/install.sh" ]; then
    log_warn "bash-it install.sh not found at $BASH_IT_DIR; skipping"
    return
  fi
  log_system "running bash-it install"
  "$BASH_IT_DIR/install.sh" --silent -f && log_success "bash-it installed"
}

auth_github() {
  if ! have gh; then log_warn "gh not available; skipping GitHub login"; return; fi
  if gh auth status >/dev/null 2>&1; then log_info "GitHub already authenticated"; return; fi
  log_system "launching 'gh auth login' - follow the prompts"
  if run_interactive gh auth login; then
    log_success "GitHub authenticated"
  else
    log_warn "gh auth login skipped/failed (no tty?). Run manually: gh auth login"
  fi
}

auth_claude() {
  if ! have claude; then log_warn "claude not available; skipping Claude login"; return; fi
  if [ -f "$HOME/.claude/.credentials.json" ]; then log_info "Claude credentials already present"; return; fi
  log_system "launching 'claude' - use /login to authenticate, then exit the app"
  if run_interactive claude; then
    log_success "Claude Code session finished"
  else
    log_warn "claude launch skipped (no tty?). Run manually: claude   (then /login)"
  fi
}

summary() {
  echo
  log_system "bootstrap finished (exit code ${EXITCODE})"
  echo -e "${GREEN}Next:${NC} source ~/.bashrc"
  [ "$DO_AUTH" = "false" ] && echo -e "      (auth skipped) run: ${GRAY}gh auth login${NC} and ${GRAY}claude${NC} then ${GRAY}/login${NC}"
  true
}

# ---------------------------------------------------------------------------------------- arg parsing
while test $# -gt 0; do
  case "$1" in
    --no-auth)       DO_AUTH="false" ;;
    --no-tools)      DO_TOOLS="false" ;;
    -v | --verbose)  LOG_LEVEL="verbose" ;;
    -q | --quiet)    LOG_LEVEL="quiet" ;;
    --version)       version; exit 0 ;;
    -h | --help)     usage_and_exit 0 ;;
    -*)              arg_error "unrecognized option: $1" ;;
    *)               arg_error "unexpected argument: $1" ;;
  esac
  shift
done

# ---------------------------------------------------------------------------------------- main
log_debug "config: LOG_LEVEL=${LOG_LEVEL} DO_TOOLS=${DO_TOOLS} DO_AUTH=${DO_AUTH}"
log_debug "repos: dotfiles=${DOTFILES_REPO} bash-it=${BASH_IT_REPO} agents=${AGENTS_REPO}"

mkdir -p "$HOME/.local/bin"
export PATH="$HOME/.local/bin:$PATH"

check_dependencies

if [ "$DO_TOOLS" = "true" ]; then
  install_apt_deps
  install_gh
  install_uv
  install_claude
else
  log_info "--no-tools: skipping installation"
fi

clone_repos
symlink_dotfiles
symlink_agents
symlink_claude_settings
run_bash_it

if [ "$DO_AUTH" = "true" ]; then
  auth_github
  auth_claude
else
  log_info "--no-auth: skipping interactive logins"
fi

summary
exit "$EXITCODE"
