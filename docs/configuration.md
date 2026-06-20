---
layout: default
title: "Configuration Guide - BMAD Planning & Orchestrator"
description: "Configure the BMAD Planning & Orchestrator plugin: userConfig options, output folder, tracks, decision-log.md, and project-context.md."
keywords: "BMAD configuration, bmad-output, userConfig, track selection, decision-log, project-context, Quick Flow, BMad Method, Enterprise"
---

# Configuration Guide

The **BMAD Planning & Orchestrator** plugin is configured at two levels: **plugin-level `userConfig`** (set once at install time) and **workspace-level files** created by `bmad-init` for each project. This page covers both.

> **Attribution:** The BMAD Method™ is created and maintained by the [BMAD Code Organization](https://github.com/bmad-code-org/BMAD-METHOD). This plugin is an independent Claude Code harness — not an official BMAD product, and no endorsement is implied. All methodology credit belongs to the BMAD Code Organization.

---

## Plugin-Level `userConfig`

When you enable the plugin, Claude Code exposes a small set of `userConfig` options you can set at that point or update later.

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `outputFolder` | string | `bmad-output` | The folder under your project root where all planning artifacts are written (stories, PRD, architecture, etc.). Relative paths are resolved from the project root. |
| `defaultTrack` | string | *(none)* | Pre-select a track so `bmad-init` skips the heuristic suggestion. Accepted values: `quick-flow`, `bmad-method`, `enterprise`. Leave unset to let the skill recommend based on scope. |
| `maxParallel` | integer | `3` | Default maximum number of stories planned to run concurrently in a parallel wave. Your dev tool enforces the actual concurrency; this is a planning constraint only. |

### Examples

Default config (nothing to set — the plugin runs with these values out of the box):

```
outputFolder  = bmad-output
defaultTrack  = (not set — bmad-init suggests based on scope)
maxParallel   = 3
```

Customized config for a team that always works at BMad Method scale and wants output in `planning/`:

```
outputFolder  = planning
defaultTrack  = bmad-method
maxParallel   = 6
```

> **Note:** `userConfig` options apply globally across all projects where the plugin is active. Per-project overrides live in `config.yaml` inside the output folder (managed by `bmad-init`).

---

## Workspace Files

Running `/bmad-planning-orchestrator:bmad-init` (or just asking Claude to "initialize BMAD") scaffolds the workspace. The result under your output folder:

```
bmad-output/
├── config.yaml            # project name, track, paths — the single source of truth
├── decision-log.md        # append-only log of every major planning decision
├── project-context.md     # project "constitution" loaded by every downstream skill
└── stories/               # story context objects land here at handoff time
```

### `config.yaml`

Every planning skill reads this file to know where to write output and which track is active. `bmad-init` creates it; edit it only via `bmad-init` (Update intent) so the decision log stays consistent.

```yaml
bmad_version: "6.x"
project:
  name: "My Project"
  track: "bmad-method"        # quick-flow | bmad-method | enterprise
  created: "2026-06-19T00:00:00Z"
paths:
  output_folder: "bmad-output"
  stories_folder: "bmad-output/stories"
  decision_log: "bmad-output/decision-log.md"
  project_context: "bmad-output/project-context.md"
languages:
  communication: "English"
  document_output: "English"
```

### `decision-log.md`

An append-only thread of every major planning decision across all workflows. The first entry is always the track choice made at `bmad-init`. Subsequent skills (PRD, architecture, readiness check, etc.) append entries as they make significant choices. Do not delete entries — the log is intentionally cumulative.

The log lets you answer "why did we decide X?" months later without reconstructing context from artifact diffs.

### `project-context.md`

The project "constitution." Every downstream skill loads this file before generating any artifact so they all share the same ground truth. Fill in at least these sections after running `bmad-init`:

- **Project Goal** — one or two sentences on the outcome.
- **Primary Users** — who it is for and what they need.
- **Core Constraints** — tech, budget, timeline, compliance non-negotiables.
- **Non-Goals** — what is explicitly out of scope (prevents drift).
- **Key Decisions** — a pointer to `decision-log.md` for the running thread.

Keep it tight and current. When scope changes significantly, update this file and append the change to the decision log.

---

## Tracks

Tracks are how the plugin right-sizes planning to the actual scope of work. There are exactly three — no numbered levels.

| Track | Typical story count | Required planning artifacts |
|-------|--------------------|-----------------------------|
| **Quick Flow** | 1–15 stories | tech-spec only |
| **BMad Method** | 10–50+ stories | PRD + Architecture (+ optional UX) |
| **Enterprise** | 30+ stories | PRD + Architecture + Security plan + DevOps plan |

Story count is a soft signal. The real driver is how much up-front structure the work needs to stay coordinated and de-risked.

### Quick Flow

Use Quick Flow when the feature is well-bounded and understood, requirements are clear enough to write directly as a technical specification, and architecture decisions are either trivial or already made.

**What it requires:**
- `tech-spec.md` — single planning document covering problem, requirements, technical approach, and story list.
- `bmad-output/stories/*.story.md` — story context objects for dev handoff.

PRD and `architecture.md` are not required. Stories are compiled directly from the tech-spec.

**Planning flow:**
```
bmad-init (Quick Flow)
  → bmad-tech-spec
    → bmad-epics-and-stories
      → bmad-handoff
```

### BMad Method

Use BMad Method when the backlog spans 10+ stories, multiple distinct capabilities need coordination, or architecture decisions will affect how parallel agents build concurrently.

**What it requires:**
- `prd.md` — functional requirements, NFRs, epic outline, MoSCoW prioritization.
- `architecture.md` — system design, ADRs, FR/NFR coverage matrix, component boundaries.
- `epics.md` — ordered epic map with story lists.
- `bmad-output/stories/*.story.md` — compiled story context objects.
- `ux-design.md` *(optional)* — visual system and experience plan, only when the project has meaningful UI.

**Planning flow:**
```
bmad-init (BMad Method)
  → bmad-product-brief (optional analysis)
    → bmad-prd
      → bmad-architecture
        → bmad-ux (optional)
          → bmad-readiness-check (gate)
            → bmad-epics-and-stories
              → bmad-sprint-planning
                → bmad-parallel-plan (optional)
                  → bmad-handoff
```

### Enterprise

Use Enterprise when any of these is true: compliance or regulatory requirements are non-negotiable (SOC 2, HIPAA, GDPR, PCI, FedRAMP), security must be designed up front, DevOps and infrastructure strategy must be planned before implementation, or multiple teams are building concurrently across 30+ stories.

**What it requires:** everything BMad Method requires, plus:
- Security planning addendum — threat model, authn/authz design, encryption strategy, compliance mapping.
- DevOps planning addendum — CI/CD strategy, environment plan, IaC design, monitoring strategy.

These are **planning documents only.** The plugin never runs security scans, provisions infrastructure, or deploys pipelines.

**Planning flow:**
```
bmad-init (Enterprise)
  → bmad-product-brief / bmad-prfaq (optional)
    → bmad-prd (with Security and DevOps NFR sections)
      → bmad-architecture (with security/infra ADRs)
        → bmad-ux (optional)
          → security planning addendum
            → DevOps planning addendum
              → bmad-readiness-check (gate)
                → bmad-epics-and-stories
                  → bmad-sprint-planning
                    → bmad-parallel-plan
                      → bmad-handoff
```

### Promoting Between Tracks

Tracks are not locked at init. If scope grows during planning, promote:

- Quick Flow → BMad Method: run `bmad-prd` and `bmad-architecture` before continuing to stories.
- BMad Method → Enterprise: add security and DevOps planning passes before the readiness gate.

Record the track change in `decision-log.md` with a date and rationale, then run `bmad-init` (Update intent) to rewrite `config.yaml`.

---

## What the Plugin Does and Does Not Do

This plugin **plans and orchestrates only.** The last artifact it produces is a `ready-for-dev` story file and a `handoff-manifest.json` consumed by external dev tools.

It **never** writes application code, runs tests, lints files, checks coverage, or reviews implemented diffs. Implementation is your dev tool's job.

---

## Quick Reference

| Setting | Where | Default |
|---------|-------|---------|
| Output folder | `userConfig.outputFolder` | `bmad-output` |
| Default track | `userConfig.defaultTrack` | *(auto-suggest)* |
| Max parallel subagents | `userConfig.maxParallel` | `3` |
| Project track | `bmad-output/config.yaml` → `project.track` | Set at `bmad-init` |
| Decision log | `bmad-output/decision-log.md` | Created by `bmad-init` |
| Project constitution | `bmad-output/project-context.md` | Created by `bmad-init` |

---

## Next Steps

- [Getting Started](./getting-started) — install the plugin and run your first workflow.
- [Subagent Patterns](./subagent-patterns) — how parallel planning subagents coordinate.
- [Troubleshooting](./troubleshooting) — common issues and fixes.
