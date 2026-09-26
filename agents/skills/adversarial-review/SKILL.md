---
name: adversarial-review
description: Opt-in multi-reviewer adversarial review of high-stakes changes such as new public APIs, PR stacks, or cross-cutting configuration. Runs independent role-based reviewers, a cross-challenge round, and coordinator verification, then produces a decision brief and a GitHub-ready review. Use only when the user explicitly asks for a comprehensive or adversarial review.
---

# Adversarial review

Use this skill for changes that become hard-to-reverse contracts. Stay read-only; post or
fix only when the user asks. For ordinary reviews, use `evidence-code-review` instead.

## 1. Shared context packet

Before delegating anything, write one short, factual packet that every reviewer reads:

- **Changes:** PRs with heads, bases and stack order. Give each PR its own read-only
  worktree, plus one worktree with all of them merged to show the cumulative result.
- **Design sources:** the authoritative documents in precedence order, and which earlier
  text later decisions supersede.
- **Rules and tests:** binding repository conventions, the test baseline, and how to run
  narrow tests from each worktree.
- **Output format:** location; severity (blocker, important or minor); category;
  finding; consequence; concrete scenario; smallest fix; and confidence (verified,
  traced or suspected).

Record facts only, never proposed solutions, so reviewers are not biased.

## 2. Independent reviewers

Run the reviewers in parallel. No reviewer sees another's findings before synthesis.
Match the model tier to the task.

| Role | Tier | Focus |
|---|---|---|
| Architect | strong | responsibilities, public/private boundaries, coupling, lifecycle, naming, DRY, cost of reversal |
| Extensibility | strong | stress-test against concrete near-term consumers the user names; flag concepts that are too specific or too general too early; no speculative design |
| Adversarial correctness | strong | trace execution; probe invalid states, edge cases, serialization and copying, repeated runs, cross-PR integration; reproduce each problem with a command |
| User profiles | medium | one reviewer per profile, taken from the repository's personas file (for example `.agents/skills/code-review/personas.md`) or given by the user; trace that user's workflows |
| Minimalist | medium | challenge every abstraction; also list what is justified |
| Mechanical auditor | light | stale references, exports, docs versus code, duplicated definitions. Treat its output as leads, not conclusions |

## 3. Cross-challenge

Send the Minimalist and Extensibility reviewers each other's findings, summarized, and
ask for a rebuttal of each point. Keep any disagreement that remains unresolved.

## 4. Synthesis

Synthesis is the coordinator's job.

- Re-run every claim marked verified before using it. Drop or downgrade anything that
  does not reproduce.
- Separate correctness bugs, likely future breakage, maintainability, usability and
  style.
- For each divergence from a design decision, state the decision, the implementation,
  the consequence, and which of the two may need reconsidering.
- Present owner decisions as options with trade-offs, including where reviewers
  disagree.

## 5. Deliverables

- **Decision brief** (in chat):
  - the five to ten findings that most deserve attention;
  - merge gates: must fix, strongly consider, and safe follow-up;
  - the decisions only the owner can make.
- **GitHub review:**
  - for each PR, a review with inline comments on the narrowest changed lines and a
    short body;
  - one short stack-level summary comment that links to the per-PR reviews instead
    of repeating them.
  Follow the global external-post rules.

## Posting checklist

1. Get explicit approval to post.
2. Re-check every PR head. If one moved, re-verify the affected findings.
3. Confirm each inline anchor falls inside a diff hunk. Move the rest to the review
   body.
4. After posting, confirm the counts of posted comments.
