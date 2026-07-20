# dotfiles

My personal shell + tooling setup for fresh Ubuntu nodes with non-persistent home directories. Pull it onto a new box, run the bootstrap, and get a familiar
environment (bash-it + `bobby` theme, aliases, a cowsay/fortune greeting, and my core CLIs) in one shot.

## Usage

On a fresh node:

```bash
curl -fsSL https://raw.githubusercontent.com/kzkedzierska/dotfiles/main/bootstrap.sh | bash
```

It will then launch the interactive **GitHub** (`gh auth login`) and **Claude Code**
(`claude` → `/login`) sign-in flows so you can follow the prompts on the spot.
When ready, `source ~/.bashrc`.

The script reads those prompts from `/dev/tty`, so the login flows work even when
run through `curl … | bash`. On a host with no terminal it skips them and tells
you to run them manually.

### Options

```
--no-auth      set everything up but skip the gh / claude logins (log in later)
--no-tools     clone + symlink only, skip apt/gh/uv/claude installation
--verbose, -v  show debug logging      --quiet, -q  errors only
--help, -h     usage                   --version    print version
```

To pass flags through the one-liner, download then run:
```bash
curl -fsSL https://raw.githubusercontent.com/kzkedzierska/dotfiles/main/bootstrap.sh -o bootstrap.sh
bash bootstrap.sh --no-auth -v
```

## What the bootstrap does

1. Installs deps and CLIs: `git`, `gh`, `uv`, `claude` (Claude Code), plus the greeting deps `cowsay`, `fortune-mod`, `lolcat`.
2. Clones into `~/github/`: this repo (`dotfiles`), my [bash-it fork](https://github.com/kzkedzierska/bash-it), and my [instructing_agents](https://github.com/kzkedzierska/instructing_agents) repo.
3. Symlinks the dotfiles into `$HOME`.
4. Symlinks agent instructions: `~/.config/AGENTS.md` and `~/.claude/CLAUDE.md` both point at the `instructing_agents` repo (single source of truth).
5. Symlinks `~/.claude/settings.json` to the copy in this repo.
6. Runs the bash-it installer.
7. Launches `gh auth login` and `claude` for interactive sign-in (unless `--no-auth`).

Every step is idempotent, so the script is safe to re-run. Edit the `*_REPO`
variables at the top of [bootstrap.sh](bootstrap.sh) (or set them as env vars) if
you fork these under a different account.

## What's here

- `.bashrc`, `.bash_profile`, `.bash_aliases`, `.inputrc`, `.screenrc` — shell / terminal config
- `.gitconfig` — git identity + defaults (no credentials; see below)
- `claude/settings.json` — Claude Code UI/behavior prefs (theme, effort, thinking) — **no secrets**
- `bootstrap.sh` — one-shot provisioning script

## Secrets & credentials — intentionally excluded

> [!CAUTION]
> No secrets live in this repo. Nothing is committed for: SSH keys, `.netrc`, `.aws` credentials, `.gnupg`, `.password-store`.

Credentials are set up **interactively, per node**, and are kept fully separate from the config here:

- **Claude Code** — auth token lives in `~/.claude/.credentials.json` (created by `claude` → `/login`), never in `settings.json`. Machine-local, non-shared, and secret overrides go in `~/.claude/settings.local.json` (auto-gitignored).
- **GitHub** — `gh auth login`. The `.gitconfig` here deliberately drops the machine-specific VS Code credential helper.
