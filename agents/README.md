# Coding-agent configuration

`AGENTS.md` is the canonical, secret-free policy shared by Codex, Claude Code, and
local GitHub Copilot CLI sessions. `CLAUDE.md` imports that policy and adds a small
Claude-specific overlay.

Run the installer from the repository root:

```sh
./install/agents.sh
./install/agents.sh --check
```

It creates instruction links and local settings copies:

```text
~/.config/agent-instructions/AGENTS.md -> agents/AGENTS.md
~/.config/AGENTS.md                   -> agents/AGENTS.md (legacy-compatible entry point)
~/.codex/AGENTS.md                    -> agents/AGENTS.md
~/.claude/AGENTS.md                   -> agents/AGENTS.md
~/.claude/CLAUDE.md                   -> agents/CLAUDE.md
~/.copilot/copilot-instructions.md    -> agents/AGENTS.md
~/.codex/config.toml                  local copy of codex/config.toml
~/.claude/settings.json               local copy of claude/settings.json
```

Existing non-symlink files are never overwritten by the default mode. Settings are copied with mode `0600`,
not linked, because tools may write private machine/account state to them. Review local
settings, then rerun with `--backup-existing` to move them into a timestamped directory
under `${XDG_STATE_HOME:-~/.local/state}/dotfiles-backups/` before installing fresh
template copies.

The installer honors `XDG_CONFIG_HOME`, `XDG_STATE_HOME`, `CODEX_HOME`,
`CLAUDE_CONFIG_DIR`, and `COPILOT_HOME`.

Default installation automatically migrates only the exact links created by the old
`instructing_agents` bootstrap and preserves them in the backup directory. All unknown
links and files still require explicit review and `--backup-existing`.

Model IDs are intentionally pinned in the templates for consistent behavior. Model
availability is account- and CLI-version-dependent; if a node rejects a pinned model,
edit only its local copied settings after confirming an available equivalent. Do not
put account details into the tracked template.

## Instruction layering

- Global policy: generic behavior that is useful in nearly every repository.
- Tool overlay: only behavior unique to one agent.
- Machine-local configuration: ignored local files or environment injection; never
  commit hostnames, tokens, keys, account identifiers, or private endpoints.
- Repository `AGENTS.md`: project purpose, architecture, commands, contracts, and
  gotchas. Do not repeat global policy unless a hosted agent cannot receive it.
- Nested instructions: rules for one subtree only.

Claude Code reads project `CLAUDE.md`, not project `AGENTS.md`. In repositories shared
with Copilot, prefer `.claude/CLAUDE.md` containing `@../AGENTS.md`; this keeps the
Claude import out of Copilot's root instruction discovery and avoids duplicate context.

GitHub Copilot agent surfaces read a repository `AGENTS.md` directly. Copilot CLI also
reads the installed personal instructions. GitHub-hosted agents cannot see home-directory
dotfiles, so any must-have policy for cloud execution belongs in the repository's
`AGENTS.md`. The project template contains a deliberately small portable core for this.

Do not add `.github/copilot-instructions.md` just to copy `AGENTS.md`; applicable files
are combined and duplicate sources waste context. In Copilot CLI, use `/instructions`
to inspect the files loaded for a repository and disable an unintended duplicate.

Claude Code may prompt for trust and marketplace/plugin installation the first time it
loads the configured `marimo-pair` marketplace on a new node. This is expected; no
credentials are stored in the settings file.

Agent teams are experimental and token-intensive, so they are not enabled globally.
Set `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` only on nodes or sessions where a task
genuinely benefits from independent parallel contexts.

Use `templates/project-AGENTS.md` as a checklist, deleting headings that add no useful
context.
