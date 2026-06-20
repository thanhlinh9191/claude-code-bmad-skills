# Migration guide

This project changed shape in two ways:

1. **Skills installer → Claude Code plugin.** The old `install-v6.sh` /
   `install-v6.ps1` scripts (which copied files into `~/.claude/skills/bmad/…`)
   are gone. Distribution is now a **plugin marketplace**.
2. **Full lifecycle → planning & orchestration only.** The `developer` skill,
   the `/dev-story` command, and all code-execution helpers (lint, coverage,
   pre-commit) were **removed**. So were Fibonacci story points, velocity, and
   burndown. BMAD now plans and orchestrates; your dev tools implement.

## From the old skills install

1. **Remove the old install** (it lived under `~/.claude`):

   ```bash
   rm -rf ~/.claude/skills/bmad
   rm -rf ~/.claude/commands/bmad
   rm -rf ~/.claude/config/bmad
   ```

2. **Install the plugin:**

   ```text
   /plugin marketplace add aj-geddes/claude-code-bmad-skills
   /plugin install bmad-planning-orchestrator@bmad-method-harness
   ```

3. `/reload-plugins` (or restart Claude Code).

## What moved

| Old | New |
|-----|-----|
| `/workflow-init`, `/workflow-status` | `bmad-init`, `bmad-help` |
| `/product-brief`, `/brainstorm`, `/research` | `bmad-product-brief`, `bmad-brainstorm`, `bmad-research` |
| `/prd`, `/tech-spec` | `bmad-prd` *(Create/Update/Validate)*, `bmad-tech-spec` |
| `/architecture`, `/solutioning-gate-check` | `bmad-architecture`, `bmad-readiness-check` |
| `/create-ux-design` | `bmad-ux` (two docs: `DESIGN.md` + `EXPERIENCE.md`) |
| `/sprint-planning`, `/create-story` | `bmad-sprint-planning`, `bmad-epics-and-stories` |
| `/create-agent`, `/create-workflow` | `bmad-builder` |
| Project Levels 0–4 | Tracks: Quick Flow / BMad Method / Enterprise |
| **`/dev-story`, `developer` skill, lint/coverage** | **Removed** — handed off to your dev tool |
| Fibonacci points / velocity / burndown | Removed — one-dev-day sizing + count-based delivery |

## New capabilities

- `bmad-spec` (five-field `SPEC.md` kernel), `bmad-prfaq` (Working Backwards),
  `bmad-investigate` (forensic triage), `bmad-document-project` (brownfield scan).
- `bmad-parallel-plan` + `bmad-handoff` — dependency-ordered parallel **waves**
  and a tool-agnostic `handoff-manifest.json` for external dev runners.
- A persistent `decision-log.md` and a `project-context.md` "constitution."

## What didn't change

The **BMAD Method™** still belongs to the **BMAD Code Organization**, and this is
still just a harness for it. See
[`bmad-planning-orchestrator/ATTRIBUTION.md`](bmad-planning-orchestrator/ATTRIBUTION.md).
