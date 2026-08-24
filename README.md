# dotfiles

My personal shell + tooling setup for fresh Ubuntu nodes with non-persistent home directories. Pull it onto a new box, run the bootstrap, and get a familiar
environment (bash-it + `bobby` theme, aliases, a cowsay/fortune greeting, and my core CLIs) in one shot.

## Usage

On a fresh node:

```bash
curl -fsSL https://raw.githubusercontent.com/kzkedzierska/dotfiles/main/bootstrap.sh | bash
```

It will then launch the interactive **GitHub**, **Codex**, **Claude Code**, and
**GitHub Copilot CLI** sign-in flows so you can follow the prompts on the spot.
When ready, `source ~/.bashrc`.

The script reads those prompts from `/dev/tty`, so the login flows work even when
run through `curl … | bash`. On a host with no terminal it skips them and tells
you to run them manually.

### Options

```
--no-auth      set everything up but skip interactive agent logins (log in later)
--no-tools     clone + symlink only, skip apt and CLI installation
--verbose, -v  show debug logging      --quiet, -q  errors only
--help, -h     usage                   --version    print version
```

To pass flags through the one-liner, download then run:
```bash
curl -fsSL https://raw.githubusercontent.com/kzkedzierska/dotfiles/main/bootstrap.sh -o bootstrap.sh
bash bootstrap.sh --no-auth -v
```

## What the bootstrap does

1. Installs deps and CLIs: `git`, `gh`, `uv`, `codex`, `claude` (Claude Code),
   and `copilot`, plus the greeting deps `cowsay`, `fortune-mod`, `lolcat`.
2. Clones into `~/github/`: this repo (`dotfiles`) and my [bash-it fork](https://github.com/kzkedzierska/bash-it).
3. Symlinks the dotfiles into `$HOME`.
4. Symlinks the shared agent policy into Codex, Claude Code, and GitHub Copilot CLI.
5. Copies secret-free Codex and Claude settings into local mode-`0600` files. Writable
   settings are deliberately not symlinked into this public checkout.
6. Runs the bash-it installer.
7. Launches interactive sign-in for GitHub, Codex, Claude Code, and Copilot CLI
   (unless `--no-auth`).

Existing checkouts are updated only with fast-forward pulls, existing home files are
backed up before links replace them, and agent configuration is validated after
installation. Edit the `*_REPO`
variables at the top of [bootstrap.sh](bootstrap.sh) (or set them as env vars) if
you fork these under a different account.

The bootstrap follows each CLI's current stable release channel, so it reproduces the
configuration and install process rather than freezing tool binaries forever. Run
`./install/check-prerequisites.sh` to record and compare installed versions across
nodes. Experiments that require bit-identical tools should pin them in the project
environment or compute image, where their compatibility can be tested with that code.

## What's here

- `.bashrc`, `.bash_profile`, `.bash_aliases`, `.inputrc`, `.screenrc` — shell / terminal config
- `.gitconfig` — git identity + defaults (no credentials; see below)
- `agents/` — canonical shared agent policy, Claude overlay, and project template
- `codex/config.toml`, `claude/settings.json` — secret-free local settings templates
- `install/agents.sh` — safe, idempotent agent configuration installer
- `bootstrap.sh` — one-shot provisioning script

## Secrets & credentials — intentionally excluded

> [!CAUTION]
> No secrets live in this repo. Nothing is committed for: SSH keys, `.netrc`, `.aws` credentials, `.gnupg`, `.password-store`.

Credentials are set up **interactively, per node**, and are kept fully separate from the config here:

- **Claude Code** — auth token lives in `~/.claude/.credentials.json` (created by `claude` → `/login`), never in `settings.json`. Machine-local, non-shared, and secret overrides go in `~/.claude/settings.local.json` (auto-gitignored).
- **GitHub** — `gh auth login`. The `.gitconfig` here deliberately drops the machine-specific VS Code credential helper.

## Coding-agent instructions

Generic behavior lives in [`agents/AGENTS.md`](agents/AGENTS.md). Repository-level
`AGENTS.md` files should contain only project contracts, commands, architecture, and
gotchas, plus the small portable core needed by GitHub-hosted agents. Claude projects
shared with Copilot can add `.claude/CLAUDE.md` containing `@../AGENTS.md` rather than
duplicating instructions or creating a second root instruction source.

To install or validate only the agent configuration:

```bash
./install/agents.sh
./install/agents.sh --check
```

The default installer automatically migrates only the exact symlinks created by the
previous `instructing_agents` setup. Unknown conflicts are never overwritten. After a
successful migration, `instructing_agents` is no longer needed on the machine.

If existing files conflict, inspect them before running
`./install/agents.sh --backup-existing`. Backups stay outside the repository under the
local state directory with restrictive permissions.

Before pushing setup changes, run `uvx pre-commit run --all-files`. GitHub CI runs the
same checks, including `detect-secrets`. Repository secret scanning and push protection
should also remain enabled.
