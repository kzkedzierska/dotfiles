#!/bin/sh

set -eu

usage() {
    cat <<'EOF'
Usage: install/agents.sh [--check | --backup-existing]

  (no option)          Create missing links; refuse to overwrite existing files.
  --check              Validate links and local config files without changing them.
  --backup-existing    Back up conflicts/local configs, then install fresh copies.
EOF
}

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo_dir=$(CDPATH= cd -- "$script_dir/.." && pwd)
mode=install
umask 077

xdg_config_home=${XDG_CONFIG_HOME:-"$HOME/.config"}
xdg_state_home=${XDG_STATE_HOME:-"$HOME/.local/state"}
codex_home=${CODEX_HOME:-"$HOME/.codex"}
claude_home=${CLAUDE_CONFIG_DIR:-"$HOME/.claude"}
copilot_home=${COPILOT_HOME:-"$HOME/.copilot"}
agents_home=${AGENTS_HOME:-"$HOME/.agents"}

case "${1-}" in
    "") ;;
    --check) mode=check ;;
    --backup-existing) mode=backup ;;
    -h|--help) usage; exit 0 ;;
    *) usage >&2; exit 2 ;;
esac

if [ "$#" -gt 1 ]; then
    usage >&2
    exit 2
fi

timestamp=$(date '+%Y%m%d-%H%M%S')
backup_dir="$xdg_state_home/dotfiles-backups/$timestamp"

backup_target() {
    target_path=$1
    relative_target=${target_path#"$HOME"/}
    saved_path="$backup_dir/$relative_target"
    mkdir -p "$(dirname -- "$saved_path")"
    if [ -e "$saved_path" ] || [ -L "$saved_path" ]; then
        printf 'backup destination already exists: %s\n' "$saved_path" >&2
        return 1
    fi
    mv "$target_path" "$saved_path"
    printf 'backed up: %s -> %s\n' "$target_path" "$saved_path"
}

is_known_legacy_instruction_link() {
    target_path=$1
    [ -L "$target_path" ] || return 1
    link_target=$(readlink "$target_path")
    if [ "$target_path" = "$xdg_config_home/AGENTS.md" ] &&
        [ "$link_target" = "$HOME/github/instructing_agents/AGENTS.md" ]; then
        return 0
    fi
    if [ "$target_path" = "$claude_home/CLAUDE.md" ] &&
        { [ "$link_target" = "$HOME/.config/AGENTS.md" ] ||
          [ "$link_target" = "$xdg_config_home/AGENTS.md" ]; }; then
        return 0
    fi
    return 1
}

link_one() {
    source_path=$1
    target_path=$2

    if [ ! -e "$source_path" ]; then
        printf 'missing source: %s\n' "$source_path" >&2
        return 1
    fi

    if [ -L "$target_path" ] && [ "$(readlink "$target_path")" = "$source_path" ]; then
        printf 'ok: %s\n' "$target_path"
        return 0
    fi

    if [ "$mode" = check ]; then
        printf 'invalid or missing link: %s (expected %s)\n' "$target_path" "$source_path" >&2
        return 1
    fi

    if [ -e "$target_path" ] || [ -L "$target_path" ]; then
        if [ "$mode" != backup ] && ! is_known_legacy_instruction_link "$target_path"; then
            printf 'refusing to overwrite %s; rerun with --backup-existing after review\n' "$target_path" >&2
            return 1
        fi
        backup_target "$target_path" || return 1
    fi

    mkdir -p "$(dirname -- "$target_path")"
    ln -s "$source_path" "$target_path"
    printf 'linked: %s -> %s\n' "$target_path" "$source_path"
}

copy_config() {
    source_path=$1
    target_path=$2

    if [ ! -e "$source_path" ]; then
        printf 'missing source: %s\n' "$source_path" >&2
        return 1
    fi

    if [ "$mode" = check ]; then
        if [ -f "$target_path" ] && [ ! -L "$target_path" ]; then
            mode_bits=$(stat -c '%a' "$target_path" 2>/dev/null || stat -f '%Lp' "$target_path" 2>/dev/null || printf 'unknown')
            if [ "$mode_bits" != 600 ]; then
                printf 'unsafe permissions on %s: %s (expected 600)\n' "$target_path" "$mode_bits" >&2
                return 1
            fi
            if cmp -s "$source_path" "$target_path"; then
                printf 'ok: %s (matches template)\n' "$target_path"
            else
                printf 'ok: %s (local settings differ from template)\n' "$target_path"
            fi
            return 0
        fi
        printf 'missing local config or unsafe symlink: %s\n' "$target_path" >&2
        return 1
    fi

    if [ -L "$target_path" ] || { [ -e "$target_path" ] && [ ! -f "$target_path" ]; }; then
        if [ "$mode" != backup ] && { [ ! -L "$target_path" ] || [ "$(readlink "$target_path")" != "$source_path" ]; }; then
            printf 'refusing unsafe config symlink/type: %s; use --backup-existing to replace it\n' "$target_path" >&2
            return 1
        fi
    elif [ -f "$target_path" ]; then
        if [ "$mode" != backup ]; then
            chmod 600 "$target_path"
            printf 'kept local config with mode 600: %s (use --backup-existing to refresh)\n' "$target_path"
            return 0
        fi
    fi

    if [ -e "$target_path" ] || [ -L "$target_path" ]; then
        backup_target "$target_path" || return 1
    fi

    mkdir -p "$(dirname -- "$target_path")"
    cp "$source_path" "$target_path"
    chmod 600 "$target_path"
    printf 'installed local config: %s (template: %s)\n' "$target_path" "$source_path"
}

install_shared_skills() {
    for skill_path in "$repo_dir"/agents/skills/*; do
        [ -d "$skill_path" ] || continue
        skill_name=${skill_path##*/}
        link_one "$skill_path" "$agents_home/skills/$skill_name" || status=1
        link_one "$skill_path" "$claude_home/skills/$skill_name" || status=1
    done
}

status=0
printf 'Codex home: %s\nClaude config: %s\nCopilot home: %s\nShared skills: %s\n' \
    "$codex_home" "$claude_home" "$copilot_home" "$agents_home/skills"
link_one "$repo_dir/agents/AGENTS.md" "$xdg_config_home/agent-instructions/AGENTS.md" || status=1
link_one "$repo_dir/agents/AGENTS.md" "$xdg_config_home/AGENTS.md" || status=1
link_one "$repo_dir/agents/AGENTS.md" "$codex_home/AGENTS.md" || status=1
link_one "$repo_dir/agents/AGENTS.md" "$claude_home/AGENTS.md" || status=1
link_one "$repo_dir/agents/CLAUDE.md" "$claude_home/CLAUDE.md" || status=1
link_one "$repo_dir/agents/AGENTS.md" "$copilot_home/copilot-instructions.md" || status=1
copy_config "$repo_dir/codex/config.toml" "$codex_home/config.toml" || status=1
copy_config "$repo_dir/claude/settings.json" "$claude_home/settings.json" || status=1
install_shared_skills

exit "$status"
