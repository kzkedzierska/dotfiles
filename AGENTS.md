# Dotfiles repository guide

## Purpose

This is a public setup repository for Ubuntu compute nodes, with portable agent
configuration that also works on macOS. Changes must remain reproducible, reviewable,
and free of credentials or private data.

## Layout

- `bootstrap.sh`: idempotent Ubuntu node provisioning.
- `agents/`: canonical shared agent policy, Claude overlay, and project template.
- `codex/` and `claude/`: secret-free settings templates copied into home directories.
- `install/agents.sh`: portable agent setup and validation.
- Root shell/editor dotfiles are linked into `$HOME`; `git/gitconfig` is copied to a
  writable, machine-local `~/.gitconfig`.

## Contracts

- Never adopt an existing home-directory file into this repository automatically.
  Preserve conflicts outside the checkout and require explicit user review.
- Do not commit tokens, keys, credentials, private endpoints, patient/private data, or
  machine-specific authentication state. Examples and placeholders must be unmistakably
  fake.
- Keep `install/agents.sh` POSIX `sh` compatible and safe on macOS and Linux.
- Keep the global policy concise and generic. Put project-, tool-, or host-specific rules
  in their narrower layer.

## Verification

```sh
bash -n bootstrap.sh
sh -n install/agents.sh install/check-prerequisites.sh
uvx pre-commit run --all-files
```

Test installer mutations with an isolated temporary `HOME`, never against the user's
real configuration during automated validation.
