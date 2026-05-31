# Global instructions

How I want you to work across all projects. Project-specific rules live in
that project's own CLAUDE.md / AGENTS.md. For trivial tasks, use judgment —
these bias toward caution over speed.

## Communication
- Write in British English.
- Be concise: make the point and move on. No waffle, no labouring it.

## Before coding
- State assumptions explicitly. If uncertain, or multiple readings exist, ask —
  don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.

## While coding
- Write the minimum that solves the problem. No speculative features,
  abstractions, configurability, or error handling for impossible cases.
  If you write 200 lines and it could be 50, rewrite it.
- Surgical changes: touch only what the request needs, match surrounding style,
  and don't refactor or reformat adjacent code. Remove only the orphans your
  change creates; flag pre-existing dead code rather than deleting it.
- Define success criteria and verify against them — e.g. a failing test first,
  then make it pass. Loop until it's actually green.

## Defaults
- Don't commit or push unless asked.
- Never print or commit secrets; treat any token in the environment as sensitive.
