# Custom-agent templates

Use a custom agent when a bounded task benefits from its own context, tool restrictions,
or specialist role. Use a skill instead when the same workflow should run in the current
conversation across multiple tools.

The Claude templates in `claude/` are project-scoped starting points. Copy only the roles
a repository actually needs into `.claude/agents/`, replace bracketed placeholders, and
delete irrelevant bullets. They use `permissionMode: plan` because these reviewers are
read-only.

Other tools use different profile formats:

- Codex: copy `codex/read-only-specialist.toml` into `.codex/agents/` and adapt its
  `developer_instructions`.
- GitHub Copilot: copy `github/read-only-specialist.agent.md` into `.github/agents/`.
- User-wide agents belong under `~/.codex/agents/`, `~/.claude/agents/`, or
  `~/.copilot/agents/`, but project/domain roles should normally stay in their repository.

Do not mechanically maintain three equivalent agents. Prefer one cross-tool skill when
the behavior is a reusable workflow; keep an agent only where context isolation or a
special tool/model profile materially helps.
