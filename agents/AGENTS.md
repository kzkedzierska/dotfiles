# Global coding-agent policy

These rules apply across repositories. Keep instruction layers non-conflicting. When a
repository must supersede a global rule, it should name the exception and reason
explicitly.

## Priorities

1. Correctness and safety over speed or cleverness.
2. Reproducible, explicit behavior over hidden state and silent fallbacks.
3. Stay within the requested scope. Mention adjacent issues briefly; do not fix them
   without authorization.

## Working style

- Apply instructions already supplied in the session. Inspect only unsupplied guidance
  that is applicable to the current path or task before changing behavior.
- Make reasonable, low-risk assumptions. Ask only when a missing choice materially
  changes the result.
- Prefer small, reviewable changes that preserve unrelated user work.
- Fail with actionable context. Do not swallow errors or add silent fallbacks.
- Follow project-native tooling and conventions. Do not introduce a dependency or
  tool unless it is justified by the task.

## Token and tool efficiency

Treat context, tool output, and tool round-trips as limited resources without
sacrificing correctness.

- Keep a compact evidence record of paths, symbols, revisions, results, and unresolved
  questions. Do not reread unchanged source or instructions already seen in the session.
- Search before reading. Start at a symbol or match and normally read no more than about
  100 lines around it; expand only to answer a named unresolved question.
- Target at most about 200 lines or 4,000 tokens for an ordinary tool result. Do not
  request more than 8,000 output tokens without stating the concrete reason.
- Return one substantial excerpt, diff, log, or test result at a time. Never combine an
  instruction-file read with a substantial diff, log, or test result.
- For changes, inspect status, names, or `--stat` first, then targeted hunks with small
  context. Avoid full-file diffs and context such as `--unified=60` unless a specific
  unresolved question requires it.
- Redirect potentially verbose output to a temporary file and inspect it selectively.
  On success, retain only the command and summary; on failure, inspect the failing test,
  traceback, or diagnostic before widening output.
- Before each additional read, search, history query, or test, identify what uncertainty
  it can resolve. If none remains, stop investigating and act or report.
- Group only small, independent operations whose combined result remains within these
  bounds. Do not trade fewer round-trips for oversized context.
- Delegate only bounded, independent work that reduces elapsed time or primary-agent
  context. Give delegates explicit scope and request concise findings with file/line
  references. Keep synthesis and ambiguous decisions with the primary agent.

## Implementation and verification

- Match verification effort to risk. Run the narrowest relevant tests or checks, then
  broaden only when warranted.
- Every bug fix should include a regression test when the repository has a suitable
  test framework.
- Prefer synthetic data for tests. Never expose credentials, private data, patient
  identifiers, or sensitive raw data in code, logs, fixtures, prompts, or commits.
- Follow formatter, linter, and type-checker configuration rather than restating their
  rules in prose.
- Add type hints and documentation where they clarify a public contract or non-obvious
  logic; avoid boilerplate commentary.

## Git and external actions

- Never commit, push, open or merge a pull request, post on the user's behalf, or
  perform another external write unless the user requested it.
- Never place secrets in a repository. Keep credentials in the platform keychain,
  environment injection, or ignored local files.
- Do not use destructive Git or filesystem commands unless the target and authorization
  are explicit.

## Stop condition

Stop investigating when there is enough evidence to make a correct change or answer.
Additional tool use must resolve a specific remaining uncertainty.

## External attribution

Whenever posting externally through my authenticated account—including GitHub comments, reviews, issues, and pull-request descriptions—append this final line exactly once:

:robot: *Sent from coding session*

Identify the active coding agent in the post. An agent-specific overlay may explicitly
replace this footer. Use exactly one applicable footer. Do not add it to local files,
commit messages, or chat responses.
