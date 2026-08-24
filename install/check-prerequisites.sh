#!/bin/sh

set -eu

missing=0

check() {
    name=$1
    purpose=$2
    if command -v "$name" >/dev/null 2>&1; then
        version=$("$name" --version 2>/dev/null | sed -n '1p' || true)
        printf 'ok: %-12s %s%s\n' "$name" "$purpose" "${version:+ ($version)}"
    else
        printf 'missing: %-7s %s\n' "$name" "$purpose"
        missing=1
    fi
}

check git 'clone and version dotfiles'
check gh 'authenticate GitHub and provide Git credentials'
check uv 'run Python tools and repository checks'
check codex 'use Codex configuration'
check claude 'use Claude Code configuration'
check copilot 'use GitHub Copilot CLI personal instructions'

if command -v pre-commit >/dev/null 2>&1 || command -v uvx >/dev/null 2>&1; then
    printf 'ok: %-12s %s\n' 'pre-commit' 'run repository safety checks directly or through uvx'
else
    printf 'missing: %-7s %s\n' 'pre-commit' 'install pre-commit or uv to run safety checks'
    missing=1
fi

if [ "$missing" -ne 0 ]; then
    printf '\nInstall missing tools with the package manager approved for this machine.\n' >&2
    exit 1
fi
