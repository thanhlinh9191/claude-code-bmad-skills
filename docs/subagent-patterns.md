---
layout: default
title: "Planning Fan-Out & Parallel Workstreams"
description: "How the BMAD Planning & Orchestrator plugin fans out planning work across three subagents (story-author, epic-scoper, readiness-auditor), how parallel WORKSTREAM planning differs from running dev agents, and how conflict-free wave design hands off to external dev tools."
keywords: "BMAD subagents, planning fan-out, parallel workstreams, story-author, epic-scoper, readiness-auditor, conflict-free waves"
---

# Planning Fan-Out & Parallel Workstreams

The **BMAD Planning & Orchestrator** plugin is a Claude Code plugin that implements the **BMAD Method** for planning and orchestration. It fans out planning work across three specialized subagents, then produces conflict-free wave plans that external dev tools can execute in parallel. The plugin plans. It never writes code, runs tests, lints, checks coverage, or reviews diffs.

> **Attribution:** The BMAD Method (Breakthrough Method for Agile AI-Driven Development) belongs to the [BMAD Code Organization](https://github.com/bmad-code-org/BMAD-METHOD). This plugin is an independent Claude Code harness — not an official BMAD product and no endorsement is implied. All methodology credit belongs to the BMAD Code Organization.

---

## Install

```text
/plugin marketplace add aj-geddes/claude-code-bmad-skills
/plugin install bmad-planning-orchestrator@bmad-method-harness
/reload-plugins
```

Local dev / testing:

```text
claude --plugin-dir ./bmad-planning-orchestrator
```

Skills are namespaced `/bmad-planning-orchestrator:<skill>` and most auto-invoke based on what you are doing. See [Getting Started](getting-started.md) for the full walkthrough.

---

## What "fan-out" means here

The plugin does not fan out to run many dev agents simultaneously. It fans out to **plan** simultaneously. The distinction matters:

| Fan-out type | What runs in parallel | Output |
|--------------|-----------------------|--------|
| **Planning fan-out** (this plugin) | Planning subagents drafting epics, stories, audit reports | `*.story.md` files, scope manifests, audit verdicts |
| **Dev execution fan-out** (external) | Dev tools building stories in isolated git worktrees | Implemented code on `story/*` branches |

The plugin's job ends when it emits `ready-for-dev` story files and a `handoff-manifest.json`. Everything after that handoff — running dev agents, managing worktrees, merging branches, running tests — belongs to your external dev tooling.

---

## The three planning subagents

The plugin ships three subagents that the orchestrating skills (`bmad-epics-and-stories`, `bmad-readiness-check`) spawn in parallel during the Solutioning and Implementation-Handoff phases.

### story-author

**Role:** Compiles one story file as a fully source-cited context object.

The `story-author` subagent receives a single story assignment (epic number, story number, slug, and a shared sharding-context path written by the orchestrator before fan-out). It reads the planning corpus — PRD, architecture document, UX design if present, and completed sibling stories — and produces one `{epic}.{story}.{slug}.story.md` that is self-contained at roughly 8K tokens.

Every claim in Dev Notes carries a source citation back to the planning documents (`[Source: architecture.md#auth-service]`, `[Source: prd.md#FR-12]`). Inferences not found verbatim in source documents are labeled `[Inference]`. The story-author sets status to `backlog` and stops. Marking a story `ready-for-dev` is the orchestrator's job after the scope-conflict check passes.

**What it never does:** writes application code, runs tests, lints, executes shell commands, modifies planning documents, or coordinates with sibling story agents.

**Fan-out pattern:**

```
bmad-epics-and-stories (orchestrator)
  │
  ├── Write sharding-context.md  (shared context for all agents)
  │
  ├── story-author [Epic 1, Story 1]  ──▶  1.1.slug.story.md (backlog)
  ├── story-author [Epic 1, Story 2]  ──▶  1.2.slug.story.md (backlog)
  ├── story-author [Epic 2, Story 1]  ──▶  2.1.slug.story.md (backlog)
  └── story-author [Epic 2, Story 2]  ──▶  2.2.slug.story.md (backlog)
        │
        ▼  (all agents return)
  Scope-conflict check across ALL stories
        │
        ▼  (clean)
  Mark stories ready-for-dev
```

---

### epic-scoper

**Role:** Scopes one epic into an ordered story list with mutually disjoint Owned File/Module Scope boundaries.

Before `story-author` agents can compile story files, someone must decide which stories exist and what files each story is allowed to touch. That is the `epic-scoper`'s job. It receives one epic's requirements slice from the PRD, the architecture document, and any already-scoped epics (to avoid cross-epic path collisions), and it produces a scoping manifest — a JSON file listing story titles, one-line intents, proposed Owned File/Module Scopes, dependency order, and a sizing verdict per story.

The epic-scoper applies the same sizing rule as everything else in the plugin: a story must fit one dev-day (roughly 2-8 hours). If a candidate story is too large, the scoper splits it and documents the split reasoning in the manifest. The orchestrator then fans out `story-author` agents using the manifest.

**What it never does:** writes story files (that is the story-author's job), writes application code, runs tests, or modifies any source planning document.

**Fan-out pattern:**

```
bmad-epics-and-stories (orchestrator)
  │
  ├── epic-scoper [Epic 1 requirements slice]  ──▶  epic-1-scope.json
  ├── epic-scoper [Epic 2 requirements slice]  ──▶  epic-2-scope.json
  └── epic-scoper [Epic 3 requirements slice]  ──▶  epic-3-scope.json
        │
        ▼  (all scoping manifests returned)
  Cross-epic scope overlap check
        │
        ▼  (clean)
  Fan out story-author agents from manifests
```

The key output of the epic-scoper is precise, path-specific Owned File/Module Scope declarations. These are the lever that makes parallel dev safe later: stories with non-overlapping scopes can run simultaneously in separate git worktrees without file/merge conflicts.

---

### readiness-auditor

**Role:** Independently audits one artifact domain (requirements, architecture, or stories) and returns a structured PASS / CONCERNS / FAIL verdict.

The `readiness-auditor` is spawned by `bmad-readiness-check` in parallel — one auditor per artifact domain — so that requirements, architecture, and stories are all reviewed simultaneously rather than sequentially. Each auditor applies a fixed checklist against its assigned domain and returns an honest verdict without softening findings. The orchestrating skill merges the verdicts and computes the overall gate result.

Audit domains:

| Domain | What is checked |
|--------|----------------|
| **requirements** | FR completeness, verifiability, NFR presence, absence of contradictions, traceability readiness |
| **architecture** | Pattern justification, component boundaries, FR/NFR coverage, module boundary quality for parallel dev safety |
| **stories** | Required sections, AC count (≤7), every Task maps to an AC, Dev Notes citations, Owned Scope non-empty, LOCKED comments present, Dev Agent Record empty |
| **full-corpus** | All three domains in one combined report |

Verdict thresholds mirror the readiness-check gate: ≥90% pass rate is PASS, 80-89% is CONCERNS (proceed with caution), below 80% or any unmitigated FAIL item blocks the workflow.

**What it never does:** writes application code, runs tests, modifies any planning artifact, or negotiates findings. It reads and reports.

**Fan-out pattern:**

```
bmad-readiness-check (orchestrator)
  │
  ├── readiness-auditor [domain: requirements]  ──▶  audit-requirements-{date}.md
  ├── readiness-auditor [domain: architecture]  ──▶  audit-architecture-{date}.md
  └── readiness-auditor [domain: stories]       ──▶  audit-stories-{date}.md
        │
        ▼  (all verdicts returned)
  Merge verdicts (strictest domain wins)
        │
        ▼
  Overall PASS / CONCERNS / FAIL
  Write readiness-report.md
```

---

## How parallel WORKSTREAM planning works

Parallel workstream planning — via `bmad-parallel-plan` — is not about running dev agents. It is about computing which stories can safely be developed at the same time and in what order they should merge. The skill produces a `parallelization-plan.md` that your dev tool consumes.

### The two conflict layers planning prevents

The BMAD Method distinguishes two classes of collision that can occur when multiple dev agents work simultaneously:

| Layer | What collides | When it surfaces | Where prevented |
|-------|--------------|------------------|-----------------|
| **Semantic** | Behavior, contracts, shared invariants | Integration or production | Architecture (Solutioning phase) |
| **File/Merge** | Source file bytes | `git merge` | Owned File/Module Scope + worktrees + ordered merges |

Catching a conflict in a planning document costs one editing pass on one file. The same conflict caught after three stories are implemented costs reverting, re-implementing, updating LOCKED Dev Notes (which requires explicit user authorization), and re-running the conflict checker. **The BMAD Code Organization's rule of thumb: catching alignment in solutioning is approximately 10x cheaper than catching it mid-build.**

### Semantic conflict prevention (architecture phase)

The `bmad-architecture` skill locks every cross-cutting decision into `architecture.md` before any story is written. The minimum required Architecture Decision Records (ADRs) for a BMad Method project cover API style and response envelope, data model, state management, naming conventions, authN/authZ model, and error/response conventions. A downstream dev agent can follow each ADR mechanically without making judgment calls that could collide with a sibling agent's assumptions.

### File/Merge conflict prevention (story scope + waves)

Every story compiled by `bmad-epics-and-stories` declares an explicit `Owned File/Module Scope` section — a list of every path the story is permitted to create or modify. The scope-conflict checker (`scripts/scope-conflict-check.sh`) computes pairwise path intersections across all ready-for-dev stories. Any pair that shares a path must either be serialized with a Blocked-by dependency or re-sliced so their scopes are disjoint.

### Wave assignment

`bmad-parallel-plan` builds a dependency DAG from three conflict classes:

- **Ordering edges** — epic order and per-story Blocked-by dependencies
- **File-scope edges** — stories whose Owned File/Module Scopes intersect cannot share a wave
- **Semantic edges** — stories that both touch a shared cross-cutting module (auth, config, DB schema, shared types) cannot share a wave

The DAG is topologically sorted into waves. Stories in the same wave are pairwise file-disjoint and pairwise semantically safe. Wave width is capped by `maxParallel` (default 3) — a planning constraint, not an execution constraint. The dev tool decides actual concurrency.

```
Wave 1 (parallel-safe stories):
  story/1.1-user-auth      story/1.2-user-profile
  (disjoint scopes, independent — both branch off main)
        │                        │
        ▼                        ▼
  integration/wave-1  ◄── merge in ascending story ID order
        │
        ▼
  integration review checkpoint
        │
        ▼  PR: integration/wave-1 → main

Wave 2 (branches off merged main):
  story/2.1-payments       story/2.3-notification
  (no dependencies on each other; each depends on Wave 1)
        ...
```

The plugin emits branch names and merge order as recommendations. Creating worktrees, running git operations, and managing actual concurrency are the external dev tool's responsibility.

---

## The planning boundary

The plugin's last artifact is a story file at `status: ready-for-dev` and a `handoff-manifest.json`. Everything past that boundary belongs to external dev tooling.

```
PLUGIN BOUNDARY (this plugin)
  Analysis → Planning → Solutioning → Implementation-Handoff
                                              │
                                    ready-for-dev stories
                                    handoff-manifest.json
                                              │
  ════════════════════════════════════════════╪════════════════
  EXTERNAL DEV TOOLS                          │
                                       consume manifest
                                       run worktree agents
                                       execute tests
                                       merge branches
                                       review diffs
```

The handoff manifest (`handoff-manifest.json`) is a stable, versioned schema listing each ready story, its Owned File/Module Scope, its wave and parallel-set, and its dependencies. Any worktree-based or autonomous dev runner can consume it without needing to understand BMAD internals.

---

## Sizing: one dev-day decomposition, count-based delivery

Stories are sized to one dev-day (roughly 2-8 hours, one agent session). There are no Fibonacci story points, no velocity, and no burndown charts. Progress is tracked by count:

```
Stories remaining = count with status in { backlog | ready-for-dev | in-progress | review }
Stories done      = count with status: done
Completion rate   = done / total
```

Report progress as: "7 of 20 stories done (35%). Wave 1 complete; Wave 2 has 4 stories in progress."

The plugin owns the `backlog` and `ready-for-dev` statuses. All status transitions past handoff belong to external dev tooling.

---

## Tracks: Quick Flow, BMad Method, Enterprise

Fan-out depth scales with the planning track selected at `bmad-init`. Tracks are not numbered levels — they are planning-need decisions.

| Track | Story count signal | Planning fan-out |
|-------|--------------------|-----------------|
| **Quick Flow** | 1-15 stories | tech-spec → epics/stories (no PRD, no architecture) |
| **BMad Method** | 10-50+ stories | PRD + architecture + optional UX → readiness gate → epics/stories |
| **Enterprise** | 30+ stories | PRD + architecture + security/DevOps addenda → readiness gate → epics/stories |

Story count is a soft signal. The real driver is how much up-front coordination the work demands. Tracks can be promoted as scope grows; record the change in `decision-log.md`.

---

## Skill catalog context

The 20 plugin skills that fan out or coordinate planning work:

**Orchestration spine:** `bmad-help`, `bmad-init`

**Analysis:** `bmad-brainstorm`, `bmad-research`, `bmad-product-brief`, `bmad-prfaq`, `bmad-spec`

**Planning:** `bmad-prd`, `bmad-tech-spec`

**Solutioning:** `bmad-ux`, `bmad-architecture`, `bmad-epics-and-stories`, `bmad-readiness-check`

**Orchestration and handoff:** `bmad-sprint-planning`, `bmad-parallel-plan`, `bmad-handoff`

**Cross-phase and meta:** `bmad-correct-course`, `bmad-investigate`, `bmad-document-project`, `bmad-builder`

All skills are namespaced `/bmad-planning-orchestrator:<skill>`. See the [skill catalog in the README](https://github.com/aj-geddes/claude-code-bmad-skills/blob/main/bmad-planning-orchestrator/README.md) for full descriptions.

---

## Reference

- Conflict avoidance (semantic + file layers): `bmad-planning-orchestrator/resources/conflict-avoidance-guide.md`
- Story sizing and split heuristics: `bmad-planning-orchestrator/resources/story-sizing-guide.md`
- Track selection detail: `bmad-planning-orchestrator/resources/track-selection-guide.md`
- Skill-to-upstream BMAD mapping: `bmad-planning-orchestrator/resources/bmad-method-mapping.md`
- Wave algorithm and merge-order rationale: `bmad-planning-orchestrator/skills/bmad-parallel-plan/REFERENCE.md`
- Story context-object contract: `bmad-planning-orchestrator/skills/bmad-epics-and-stories/REFERENCE.md`

---

<div style="text-align: center; margin-top: 40px; padding: 20px; background: #e8f4f8; border-radius: 8px;" markdown="1">

**BMAD Method™** is created and maintained by the [BMAD Code Organization](https://github.com/bmad-code-org/BMAD-METHOD). This plugin is an independent Claude Code harness — not an official BMAD product and no endorsement is implied. All methodology credit belongs to the BMAD Code Organization.

Upstream: [github.com/bmad-code-org/BMAD-METHOD](https://github.com/bmad-code-org/BMAD-METHOD) · Docs: [docs.bmad-method.org](https://docs.bmad-method.org/) · Site: [bmadcodes.com/bmad-method](https://bmadcodes.com/bmad-method/)

</div>
