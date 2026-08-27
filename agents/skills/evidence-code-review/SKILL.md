---
name: evidence-code-review
description: Review PRs, branches, commits, patches, or working-tree changes using repository evidence and a strict finding threshold. Use for high-signal initial reviews, re-reviews, and merge-readiness assessments; remain read-only unless fixes are separately requested.
---

# Evidence Code Review

Review the actual repository state, not only a pasted diff. Prioritize actionable,
well-supported findings over speculative or repetitive commentary.

## Scope

Default to a focused review: changed lines, direct dependencies, ancestry, checks, and
targeted tests. Expand to affected integration paths only when a concrete risk requires
it. Repository-wide investigation or specialist review requires explicit user opt-in or
an unresolved finding that cannot be tested locally.

## Establish scope

1. Apply repository guidance already present in the session. Load a nearer instruction
  file only when it applies and has not already been supplied.
2. Establish the base, head, ancestry, changed paths, and diff size. Start with status,
  name-only, or stat output, then inspect targeted hunks. Cover the complete diff without
  printing it all into context at once.
3. For a GitHub pull request, inspect its purpose, checks, prior reviews, and unresolved
   threads when access is available.
4. During re-review, verify earlier findings against the current head and do not repeat
   resolved or obsolete comments.

Use focused, read-only validation when it can confirm or reject a suspected defect.
Do not edit files, submit reviews, or post comments unless the user separately authorizes
that action.

## Build evidence

- Search existing implementations, configuration, tests, or comparable modules only
  when needed to test a design, consistency, or duplication concern.
- Cite the exact existing file and symbol for a duplication finding.
- Use history only when current code cannot establish intent or compatibility.
- Trace changed values and state through relevant execution paths, especially where a
  failure could remain silent.

## Review by risk

Prioritize defects affecting users, data, scientific results, security, or
reproducibility. Check relevant risks such as:

- shape, axis, unit, boundary, filtering, aggregation, normalization, and missing-data
  semantics;
- seeds, caches, aliasing, in-place mutation, hidden state, and compatibility with
  persisted data or configuration;
- divergent success/error, training/evaluation, sync/async, lifecycle, ordering, and
  concurrency paths;
- gradients, precision, numerical stability, statistics, and data leakage;
- authorization, input validation, secret handling, and migration behavior.

Evaluate design proportionally. Apply DRY to duplicated knowledge, not similar syntax.
Flag abstraction, hardcoding, or verbosity only when it creates a concrete cost. Check
that changed behavior and bug regressions have useful tests without demanding tests of
implementation details.

## Finding threshold

Report a finding only when all four are present:

1. a precise changed-code location;
2. a reachable failure or concrete maintenance cost;
3. a meaningful consequence;
4. supporting repository or runtime evidence.

Do not report untouched pre-existing problems, vague suspicions, personal preferences,
linter trivia, resolved comments, or speculative future needs. Label a material but
unconfirmed concern as a residual risk or question, not a finding.

## Output

Lead with findings ordered by severity:

- **Blocking:** incorrect behavior, corruption, security exposure, broken
  reproducibility, or another concrete merge blocker.
- **Worth noting:** actionable but non-blocking design, readability, duplication, or
  test concern.

For each finding, provide `file:line`, the problem, consequence, evidence, and a practical
correction when it is not obvious. If no actionable findings remain, say the change is
ready from the review perspective. List material residual risks or validation gaps
separately; never invent a finding to justify the review.
