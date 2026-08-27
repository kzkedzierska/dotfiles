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

- Inspect existing code, repository instructions, and configuration before changing
  behavior.
- Make reasonable, low-risk assumptions. Ask only when a missing choice materially
  changes the result.
- Prefer small, reviewable changes that preserve unrelated user work.
- Fail with actionable context. Do not swallow errors or add silent fallbacks.
- Follow project-native tooling and conventions. Do not introduce a dependency or
  tool unless it is justified by the task.

## Token and tool efficiency

Treat context, tool output, and tool round-trips as limited resources without
sacrificing correctness.

- Start with the smallest query that can answer the current question. Search first,
  then read only relevant regions.
- Prefer targeted searches, diffs, history, and bounded log/test output over full-file
  or repository-wide dumps.
- Reuse evidence already in context. Do not repeat equivalent reads, searches, polls,
  or verification on unchanged state.
- Expand investigation only to resolve a concrete uncertainty. Once evidence is
  sufficient to act safely, act.
- Group related bounded reads when it reduces round-trips without producing excessive
  output.
- Inspect failure details and summaries; do not forward large successful logs.
- Delegate only bounded, independent work that reduces elapsed time or primary-agent
  context. Give delegates explicit scope and request concise findings with file/line
  references. Keep synthesis and ambiguous decisions with the primary agent.
- Do not reload instruction files already supplied in the session.

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

Specify what coding agent was used. Do not add this footer to local files, commit messages, or chat responses.
