# Skills and custom agents

Prefer built-in, maintained capabilities before adding personal extensions. Every skill
adds discovery metadata, and every subagent adds model/tool work, so a larger catalog is
not automatically a stronger setup.

## Built-ins worth using first

- Claude Code includes `/code-review`, `/simplify`, `/debug`, `/run`, and `/verify`.
- GitHub Copilot CLI includes `code-review`, `explore`, `task`, `research`, and
  `rubber-duck` agents.
- Codex includes general-purpose `worker` and read-heavy `explorer` agents; create a
  custom agent only for a narrower role or different model/sandbox profile.

The local `evidence-code-review` skill complements those built-ins with a stricter
repository-evidence and finding threshold. Its distinct name avoids silently replacing
Claude's or Copilot's maintained `code-review` behavior.

## Maintained skills to consider

From the official OpenAI curated catalog:

- `jupyter-notebook`: clean experiment and tutorial notebooks.
- `gh-fix-ci`: inspect and fix failing GitHub Actions checks.
- `gh-address-comments`: inspect and address pull-request feedback.
- `security-best-practices`: explicit Python, JavaScript/TypeScript, or Go security
  reviews.
- `security-threat-model`: repository-grounded AppSec threat modeling.

Install an OpenAI curated skill from a Codex prompt with, for example:

```text
$skill-installer jupyter-notebook
```

For standard public skill repositories, GitHub CLI provides a cross-agent discovery,
preview, install, and update workflow:

```sh
gh skill search jupyter
gh skill preview github/awesome-copilot documentation-writer
gh skill install github/awesome-copilot documentation-writer \
  --agent codex --scope user --pin COMMIT_OR_TAG
```

Repeat the install with `--agent claude-code` when Claude needs its own personal copy.
Preview the complete skill and supporting files before installation; do not use `--force`
as a routine update mechanism.

Claude Code discovers personal skills under `~/.claude/skills/`; Codex and Copilot both
discover the open-standard location `~/.agents/skills/`. This repository's installer
links its own reviewed skills into both locations.

## Third-party review checklist

GitHub documents `github/awesome-copilot` and `anthropics/skills` as discovery sources,
not as an instruction to trust or bulk-install everything in them. Before adopting a
third-party skill or agent:

1. Read the complete instructions and every referenced script.
2. Check its tool allowlist, shell pre-approval, hooks, MCP servers, and external URLs.
3. Reject hard-coded third-party MCP endpoints unless their data handling and access are
   acceptable for the repository.
4. Prefer a pinned commit or plugin release over an unreviewed moving branch.
5. Install only a workflow you actually use and test its triggering on representative
   tasks.

Do not vendor a community skill merely because its name sounds relevant. A short,
project-specific domain agent is often better than a generic scientific agent that adds
an external service or broad write tools.
