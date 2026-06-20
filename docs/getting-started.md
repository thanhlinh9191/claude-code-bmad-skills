---
layout: default
title: "Getting Started"
description: "Install the BMAD Planning & Orchestrator plugin from the Claude Code marketplace and run your first end-to-end planning workflow: track selection, product brief, PRD, architecture, epics and stories, readiness check, sprint planning, parallel wave plan, and dev handoff."
keywords: "BMAD installation, Claude Code plugin, BMAD planning orchestrator, agile planning, getting started"
---

# Getting Started

This guide walks you through installing the **BMAD Planning & Orchestrator** plugin from the Claude Code marketplace and completing your first full planning workflow — from `bmad-init` all the way to a `handoff-manifest.json` ready for your dev tools.

> **Attribution — required reading.** The **BMAD Method™** (Breakthrough Method for Agile AI-Driven Development) is created and maintained by the **[BMAD Code Organization](https://github.com/bmad-code-org/BMAD-METHOD)**. This plugin is an independent Claude Code harness for the method's planning and orchestration workflows — not an official BMAD product, and no endorsement is implied. All methodology credit belongs to the BMAD Code Organization. See the plugin's [ATTRIBUTION.md](https://github.com/aj-geddes/claude-code-bmad-skills/blob/main/bmad-planning-orchestrator/ATTRIBUTION.md).

---

## What this plugin does (and does not do)

The **BMAD Planning & Orchestrator** plugin plans and orchestrates. It **never** writes application code, runs tests, lints, checks coverage, or reviews diffs. Its final artifact is a `ready-for-dev` story file plus a `handoff-manifest.json` that any external dev tool can consume.

It implements the four BMAD phases — **Analysis → Planning → Solutioning → Implementation-handoff** — scaled by an interactive **track** (Quick Flow / BMad Method / Enterprise). Implementation itself is always the job of your dev tooling.

---

## Prerequisites

- **Claude Code** installed and working ([Installation Guide](https://docs.anthropic.com/en/docs/claude-code))
- Access to the Claude Code plugin marketplace

---

## Installation

### Standard install (marketplace)

Run these commands inside a Claude Code session:

```
/plugin marketplace add aj-geddes/claude-code-bmad-skills
/plugin install bmad-planning-orchestrator@bmad-method-harness
/reload-plugins
```

After `/reload-plugins` the plugin's 20 skills are available. Most auto-invoke based on context; you can also call them explicitly as `/bmad-planning-orchestrator:<skill>` (for example `/bmad-planning-orchestrator:bmad-init`).

### Local development install

If you have cloned the repository locally and want to test changes without publishing:

```bash
claude --plugin-dir ./bmad-planning-orchestrator
```

No files are copied into `~/.claude` by hand. There is no `install-v6.sh` or `install-v6.ps1`.

---

## The 20 skills at a glance

Skills are grouped by phase. `bmad-help` and `bmad-init` are the entry points.

| Group | Skills |
|-------|--------|
| **Spine** | `bmad-help`, `bmad-init` |
| **Analysis** (optional) | `bmad-brainstorm`, `bmad-research`, `bmad-product-brief`, `bmad-prfaq`, `bmad-spec` |
| **Planning** | `bmad-prd`, `bmad-tech-spec` |
| **Solutioning** | `bmad-ux`, `bmad-architecture`, `bmad-epics-and-stories`, `bmad-readiness-check` |
| **Orchestration & handoff** | `bmad-sprint-planning`, `bmad-parallel-plan`, `bmad-handoff` |
| **Cross-phase & meta** | `bmad-correct-course`, `bmad-investigate`, `bmad-document-project`, `bmad-builder` |

`bmad-help` is the orchestration spine: at any point, invoke it and it will read your artifact state and tell you which skill to run next.

---

## Your first walkthrough: BMad Method track end to end

The walkthrough below uses the **BMad Method** track (10–50+ stories, PRD + Architecture). Quick Flow (1–15 stories, tech-spec only) and Enterprise (30+ stories, adds security and DevOps planning) follow the same structure — `bmad-init` explains the differences and the track selection is always yours to confirm.

> All examples show natural-language interactions. The plugin is designed to auto-invoke the right skill based on what you say; you do not need to type the namespaced skill name unless you prefer to.

---

### Step 1 — Let `bmad-help` orient you

At the start of any session — especially when resuming work — ask:

```
What's my BMAD status?
```

`bmad-help` scans your `bmad-output/` folder, detects which planning artifacts exist, infers the current phase and track, and recommends exactly one next skill. It routes; it never writes documents itself.

If you are starting fresh, it will tell you: no workspace found — run `bmad-init`.

---

### Step 2 — Initialize the workspace with `bmad-init`

```
Initialize BMAD for this project
```

`bmad-init` asks a few lightweight questions:

- One-line project description
- Roughly how many distinct pieces of work?
- Multiple teams or a single builder?
- Hard compliance / security / infrastructure requirements?

Based on your answers it suggests a track and asks you to confirm or override:

| Track | Typical scope | Required planning |
|-------|---------------|-------------------|
| **Quick Flow** | 1–15 stories | tech-spec only |
| **BMad Method** | 10–50+ stories | PRD + Architecture (+ optional UX) |
| **Enterprise** | 30+ stories | PRD + Architecture + Security + DevOps planning |

Once you confirm, it scaffolds the planning workspace:

```
bmad-output/
├── config.yaml          # project name, track, output paths
├── decision-log.md      # grows across every planning workflow
├── project-context.md   # the project "constitution" every later skill loads
└── stories/             # empty; story files land here later
```

It then walks you through filling the first sections of `project-context.md` (goal, primary users, constraints, non-goals) and records the track decision in `decision-log.md`. A few good sentences in `project-context.md` pay dividends across every downstream workflow.

**Recommended next:** `bmad-product-brief` (optional Analysis phase) or jump straight to `bmad-prd`.

---

### Step 3 — Capture the product vision with `bmad-product-brief` (optional)

Analysis is always optional. Skip it if requirements are already clear.

```
Create a product brief
```

`bmad-product-brief` structures the opportunity: problem statement, target users, key capabilities, constraints, non-goals, and success metrics. If you want to do structured ideation or market research first, call `bmad-brainstorm` or `bmad-research` before the brief.

**Output:** `bmad-output/product-brief.md`

---

### Step 4 — Write the PRD with `bmad-prd`

```
Create a PRD
```

`bmad-prd` produces a full Product Requirements Document with labelled Functional Requirements (FR-001, FR-002 …), Non-Functional Requirements, a MoSCoW priority map, an epic outline, and a decision log update. It reads `project-context.md` and, if present, `product-brief.md`.

**Outputs:** `bmad-output/prd.md`, `bmad-output/addendum.md`, `decision-log.md` update

For Quick Flow, `bmad-tech-spec` replaces the PRD with a lighter single planning document.

---

### Step 5 — Design the architecture with `bmad-architecture`

```
Design the system architecture
```

`bmad-architecture` produces `architecture.md` plus Architecture Decision Records (ADRs). It systematically covers every NFR from the PRD and produces a component-boundary map — the **semantic-conflict prevention** layer that makes safe parallel development possible later. Clean architecture means two concurrent dev agents touching different components cannot create hidden integration conflicts.

**Outputs:** `bmad-output/architecture.md`, ADR entries in the decision log

If your project has a significant UI, run `bmad-ux` here to produce a two-document UX contract (`DESIGN.md` and `EXPERIENCE.md`) before handing to the story author.

---

### Step 6 — Decompose into epics and stories with `bmad-epics-and-stories`

```
Create epics and stories
```

`bmad-epics-and-stories` shards the PRD into epics and individual story context objects. Each story file is named `{epic}.{story}.{slug}.story.md` and carries everything an implementer needs: source-cited Dev Notes, Acceptance Criteria, a testing *strategy*, Tasks/Subtasks, a Dependency Map, and an explicit **Owned File/Module Scope**. Sections Acceptance Criteria, Dev Notes, and Testing are **locked** — external dev tools implement against them but must not edit them.

Sizing targets one-dev-day decomposition: stories are sized by count and complexity (roughly 2–8 hours each), not Fibonacci points, velocity, or burndown.

**Outputs:** `bmad-output/epics.md`, `bmad-output/stories/{epic}.{story}.{slug}.story.md` per story

---

### Step 7 — Gate the plan with `bmad-readiness-check`

```
Check if we're ready to build
```

`bmad-readiness-check` is the Solutioning gate. It cross-references the PRD, architecture document, and epic/story files for coverage consistency and returns a **PASS / CONCERNS / FAIL** verdict with specifics.

Coverage thresholds:

| Criterion | PASS | CONCERNS | FAIL |
|-----------|------|----------|------|
| FR coverage (covered + implied) | ≥ 90 % | 80–89 % | < 80 % |
| NFR coverage (addressed + partial) | ≥ 90 % | 80–89 % | < 80 % |
| Architecture quality checks | ≥ 80 % | 70–79 % | < 70 % |

A FAIL result means do not proceed to sprint planning — address the gaps and re-run the check. A CONCERNS result means proceed with caution; open items should be carried into story Dev Notes.

**Output:** `bmad-output/readiness-report-<slug>-<date>.md`

This is the gate between Solutioning and Implementation. **"Planning ends here."**

---

### Step 8 — Build the sprint roadmap with `bmad-sprint-planning`

```
Create a sprint plan
```

`bmad-sprint-planning` produces a `sprint-status.yaml` roadmap that sequences the story backlog — sprint assignments, ordering, and dependencies. There are no story points, no velocity, no burndown. Delivery is tracked by story count: stories remaining and completion rate against the backlog.

**Output:** `bmad-output/sprint-status.yaml`

---

### Step 9 — Plan concurrent waves with `bmad-parallel-plan`

```
Plan parallel work
```

`bmad-parallel-plan` turns the sequential backlog into **conflict-free concurrent waves**. It builds a dependency DAG from three conflict classes:

- **Ordering edges** — epic order and each story's explicit Dependency Map
- **File-scope edges** — any two stories whose Owned File/Module Scopes overlap must not share a wave
- **Semantic edges** — stories that touch shared cross-cutting modules identified in the architecture

Stories are topologically sorted into waves; each wave is a set of stories whose scopes are mutually disjoint and whose dependencies are already satisfied by prior waves. The architecture's clean component boundaries are what make this sorting possible without guessing.

The output assigns each story a recommended `git-worktree` branch name and provides an ordered merge sequence: ascending story id into an `integration/wave-{N}` branch, an integration review checkpoint, then a single PR to `main`. Wave N+1 branches off the merged `main`.

This skill **plans** concurrency. It never spawns worktrees, runs dev agents, writes code, or executes `git` commands — that is the job of your external dev tool.

**Outputs:** `bmad-output/parallelization-plan.md`, optional `dependency-graph.json` and `waves.json`

---

### Step 10 — Emit the handoff manifest with `bmad-handoff`

```
Generate the handoff manifest
```

`bmad-handoff` scans the output folder for all stories with status `ready-for-dev` and compiles them into a single `handoff-manifest.json` — a versioned, tool-agnostic interface any dev runner can consume.

Each story entry includes: story file path, owned scope, wave assignment, parallel set, dependency list, first-three acceptance criteria, and a locked-sections note instructing the dev tool not to modify Acceptance Criteria, Dev Notes, or Testing.

This is the last artifact the planning plugin produces. What happens next — running agents, building, testing, merging — belongs to your dev tool.

**Output:** `bmad-output/handoff-manifest.json`

---

## Using `bmad-help` throughout

At any point during the workflow, you can ask:

```
What's next?
Where am I in the BMAD flow?
Continue
```

`bmad-help` reads the current artifact state, infers the phase and track, and recommends exactly one next skill to run. It also handles skipping rules automatically: Analysis is always optional; UX is only recommended when the project has a UI; Architecture is skipped for Quick Flow.

---

## Quick reference: full BMad Method flow

```
bmad-init            → pick track, scaffold workspace + decision-log + project-context
  │
  ├─ (optional) bmad-brainstorm / bmad-research / bmad-product-brief / bmad-prfaq / bmad-spec
  │
  ├─ bmad-prd        → prd.md + addendum.md
  │
  ├─ (optional) bmad-ux  → DESIGN.md + EXPERIENCE.md  (only if UI)
  │
  ├─ bmad-architecture   → architecture.md + ADRs
  │
  ├─ bmad-epics-and-stories  → epics.md + story files
  │
  ├─ bmad-readiness-check    → PASS / CONCERNS / FAIL gate
  │
  ├─ bmad-sprint-planning    → sprint-status.yaml
  │
  ├─ bmad-parallel-plan      → parallelization-plan.md (wave assignments + merge order)
  │
  └─ bmad-handoff            → handoff-manifest.json  ──▶  YOUR DEV TOOL
```

For **Quick Flow**, replace `bmad-prd` + `bmad-architecture` with `bmad-tech-spec`, and skip `bmad-parallel-plan` unless you have concurrent agents.

---

## What to do if scope changes mid-stream

Use `bmad-correct-course`. It handles mid-stream scope changes by re-planning the affected artifacts — never re-coding. The skill updates the PRD, architecture, and story backlog; records the change in `decision-log.md`; and routes you back into the normal flow.

---

## Next steps

- **Skill reference** — detailed behavior for each of the 20 skills: [Skills](./skills/)
- **Troubleshooting** — common issues and fixes: [Troubleshooting](./troubleshooting)
- **Examples** — complete project walkthroughs: [Examples](./examples/)
- **Configuration** — output folder, default track, max parallel workstreams: [Configuration](./configuration)
- **Open an issue** — [github.com/aj-geddes/claude-code-bmad-skills/issues](https://github.com/aj-geddes/claude-code-bmad-skills/issues)

---

<div style="text-align: center; margin-top: 40px; padding: 20px; background: #e8f4f8; border-radius: 8px;" markdown="1">

**Not sure where you are?** Just say `What's next?` — `bmad-help` will orient you.

</div>
