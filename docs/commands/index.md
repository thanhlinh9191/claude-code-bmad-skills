---
layout: default
title: "Skills Reference"
description: "Complete reference for all 20 BMAD Planning & Orchestrator skills. Invoked as /bmad-planning-orchestrator:<skill> or auto-triggered by Claude. Includes migration map from old slash commands."
keywords: "BMAD skills, Claude Code plugin, bmad-planning-orchestrator, skill reference, slash commands migration, BMAD Method"
---

# Skills Reference

The **BMAD Planning & Orchestrator** plugin ships 20 skills, not slash commands. Skills are namespaced under the plugin and invoked as:

```
/bmad-planning-orchestrator:<skill-name>
```

Most skills are **auto-invoked by Claude** based on what you are doing — you rarely type the full namespace. When Claude detects that your planning workflow calls for a particular skill, it will invoke it automatically. You can always call any skill explicitly if you prefer.

> **Attribution:** The BMAD Method is created and maintained by the [BMAD Code Organization](https://github.com/bmad-code-org/BMAD-METHOD). This plugin is an independent Claude Code harness — not an official BMAD product. All methodology credit belongs to the BMAD Code Organization.

---

## What These Skills Do (and Do Not Do)

The plugin **plans and orchestrates**. It never writes application code, runs tests, lints, checks coverage, or reviews implemented diffs. The last artifact it produces is a `ready-for-dev` story file and a `handoff-manifest.json` for consumption by external dev tools.

---

## Skills by Phase

### Cross-Phase (Orchestration Spine)

| Skill | Invocation | Purpose |
|-------|-----------|---------|
| [bmad-help](#bmad-help) | `/bmad-planning-orchestrator:bmad-help` | "What do I run next?" router; reads artifact state |
| [bmad-init](#bmad-init) | `/bmad-planning-orchestrator:bmad-init` | Interactive track selection; scaffolds workspace |

### Phase 1 — Analysis (Optional)

| Skill | Invocation | Purpose |
|-------|-----------|---------|
| [bmad-brainstorm](#bmad-brainstorm) | `/bmad-planning-orchestrator:bmad-brainstorm` | Structured ideation |
| [bmad-research](#bmad-research) | `/bmad-planning-orchestrator:bmad-research` | Market / domain / technical research |
| [bmad-product-brief](#bmad-product-brief) | `/bmad-planning-orchestrator:bmad-product-brief` | Product brief (guided discovery) |
| [bmad-prfaq](#bmad-prfaq) | `/bmad-planning-orchestrator:bmad-prfaq` | Working-Backwards press release + FAQ |
| [bmad-spec](#bmad-spec) | `/bmad-planning-orchestrator:bmad-spec` | Five-field SPEC.md kernel |

### Phase 2 — Planning

| Skill | Invocation | Purpose |
|-------|-----------|---------|
| [bmad-prd](#bmad-prd) | `/bmad-planning-orchestrator:bmad-prd` | PRD with FRs/NFRs, epics, MoSCoW |
| [bmad-tech-spec](#bmad-tech-spec) | `/bmad-planning-orchestrator:bmad-tech-spec` | Lightweight tech spec (Quick Flow track) |

### Phase 3 — Solutioning

| Skill | Invocation | Purpose |
|-------|-----------|---------|
| [bmad-ux](#bmad-ux) | `/bmad-planning-orchestrator:bmad-ux` | UX contract: DESIGN.md + EXPERIENCE.md |
| [bmad-architecture](#bmad-architecture) | `/bmad-planning-orchestrator:bmad-architecture` | System architecture + ADRs |
| [bmad-epics-and-stories](#bmad-epics-and-stories) | `/bmad-planning-orchestrator:bmad-epics-and-stories` | Epics + compiled story context files |
| [bmad-readiness-check](#bmad-readiness-check) | `/bmad-planning-orchestrator:bmad-readiness-check` | PASS / CONCERNS / FAIL gate |

### Phase 4 — Implementation Handoff

| Skill | Invocation | Purpose |
|-------|-----------|---------|
| [bmad-sprint-planning](#bmad-sprint-planning) | `/bmad-planning-orchestrator:bmad-sprint-planning` | Sequence stories; emit sprint-status.yaml |
| [bmad-parallel-plan](#bmad-parallel-plan) | `/bmad-planning-orchestrator:bmad-parallel-plan` | Dependency DAG → conflict-free parallel waves |
| [bmad-handoff](#bmad-handoff) | `/bmad-planning-orchestrator:bmad-handoff` | Emit handoff-manifest.json for dev tools |

### Cross-Phase & Meta

| Skill | Invocation | Purpose |
|-------|-----------|---------|
| [bmad-correct-course](#bmad-correct-course) | `/bmad-planning-orchestrator:bmad-correct-course` | Mid-stream scope change → re-plan |
| [bmad-investigate](#bmad-investigate) | `/bmad-planning-orchestrator:bmad-investigate` | Forensic triage → investigation case file + optional fix story |
| [bmad-document-project](#bmad-document-project) | `/bmad-planning-orchestrator:bmad-document-project` | Brownfield current-state documentation (read-only) |
| [bmad-builder](#bmad-builder) | `/bmad-planning-orchestrator:bmad-builder` | Scaffold and validate custom planning skills |

---

## Tracks, Not Levels

Right-sizing uses **tracks** chosen interactively during `bmad-init`. There are no numbered Levels 0–4.

| Track | Typical story count | Required planning |
|-------|--------------------|--------------------|
| **Quick Flow** | 1–15 stories | tech-spec only |
| **BMad Method** | 10–50+ stories | PRD + Architecture (+ optional UX) |
| **Enterprise** | 30+ stories | PRD + Architecture + Security + DevOps planning |

Tracks are not locked. Scope growth can promote a project from Quick Flow to BMad Method (by running `bmad-prd` and `bmad-architecture`), or from BMad Method to Enterprise (by adding security and DevOps planning passes before the readiness gate). Record the change in `decision-log.md`.

---

## Sizing: One Dev-Day Decomposition

There are **no Fibonacci story points, no velocity, and no burndown charts** in this plugin. Stories are sized to one developer-day. Progress is tracked by count (stories delivered vs. stories remaining). Sprint sequencing assigns dependency-ordered parallel waves, not capacity-constrained sprints.

---

## Skill Detail

<h3 id="bmad-help">bmad-help</h3>

The orchestration spine. Reads the artifacts present in your workspace and routes you to the next appropriate skill. Use this any time you are unsure what to do next.

**Auto-invoked:** Yes — Claude calls this at the start of planning sessions.

**Output:** Status display; no file written.

---

<h3 id="bmad-init">bmad-init</h3>

Initializes the planning workspace. Interactively selects a track (Quick Flow / BMad Method / Enterprise), creates `config.yaml`, `decision-log.md`, and `project-context.md`. Can also be called with an Update intent to promote a track.

**Auto-invoked:** Yes — on first planning interaction in a new workspace.

**Output:** `bmad-output/config.yaml`, `bmad-output/decision-log.md`, `bmad-output/project-context.md`

---

<h3 id="bmad-brainstorm">bmad-brainstorm</h3>

Structured ideation session using techniques such as SCAMPER, SWOT, 5 Whys, and Six Thinking Hats. Parallel subagents apply different frameworks simultaneously for diverse perspective coverage.

**Output:** `bmad-output/brainstorming-report.md`

---

<h3 id="bmad-research">bmad-research</h3>

Live, web-sourced research: market, competitive, domain, and technical. Produces a cited research report. Parallel subagents cover different research dimensions concurrently.

**Output:** `bmad-output/research-report.md`

---

<h3 id="bmad-product-brief">bmad-product-brief</h3>

Guided discovery conversation (persona: Mary, Business Analyst). Produces a product brief covering problem space, target audience, competitive landscape, and business model. Supports Create / Update / Validate intents.

**Output:** `bmad-output/product-brief.md`

---

<h3 id="bmad-prfaq">bmad-prfaq</h3>

Amazon Working-Backwards press release + internal and external FAQs. Stress-tests the concept before a PRD is written.

**Output:** `bmad-output/prfaq.md`

---

<h3 id="bmad-spec">bmad-spec</h3>

Five-field distiller: Problem, Capabilities, Constraints, Non-Goals, Success Metrics. Accepts any messy input (emails, notes, conversations) and extracts a clean `SPEC.md` kernel that feeds the PRD or tech-spec.

**Output:** `bmad-output/SPEC.md`

---

<h3 id="bmad-document-project">bmad-document-project</h3>

Read-only brownfield codebase scan. Produces current-state documentation as the planning ground truth for an existing project. Does not write any application code.

**Output:** `bmad-output/project-documentation.md`

---

<h3 id="bmad-prd">bmad-prd</h3>

PRD facilitator (persona: John, Product Manager). Produces functional requirements (FR-### series), non-functional requirements (NFR-### series), a MoSCoW priority table, RICE scoring, and an epic outline. Supports Create / Update / Validate intents. Parallel subagents generate PRD sections concurrently.

**Output:** `bmad-output/prd.md`, `bmad-output/prd-addendum.md`, updates to `bmad-output/decision-log.md`

**Prerequisite:** `product-brief.md` (recommended) or direct input.

---

<h3 id="bmad-tech-spec">bmad-tech-spec</h3>

Lightweight planning document for Quick Flow track (1–15 story scope). Combines problem statement, requirements, technical approach, and story list into a single document. Replaces PRD + architecture for small-scope work.

**Output:** `bmad-output/tech-spec.md`

---

<h3 id="bmad-ux">bmad-ux</h3>

Two-document UX contract (persona: Sally, UX Designer). `DESIGN.md` covers the visual system (design tokens, component specs, WCAG 2.1 AA compliance). `EXPERIENCE.md` covers user journeys and interaction flows. Optional; only run if the project has a UI.

**Output:** `bmad-output/DESIGN.md`, `bmad-output/EXPERIENCE.md`

**Prerequisite:** `prd.md`

---

<h3 id="bmad-architecture">bmad-architecture</h3>

System architecture design (persona: Winston, Architect). Produces `architecture.md` with component boundaries, ADRs, an FR/NFR coverage matrix, and explicit API/data model/naming conventions. Architecture conventions are the primary mechanism for **semantic conflict prevention** in parallel development.

**Output:** `bmad-output/architecture.md`

**Prerequisite:** `prd.md`

---

<h3 id="bmad-epics-and-stories">bmad-epics-and-stories</h3>

Shards the PRD and architecture into an ordered `epics.md` and compiled, self-contained story context files (`{epic}.{story}.{slug}.story.md`, each approximately 8K tokens). Each story carries Dev Notes, Acceptance Criteria, a Testing strategy, Tasks/Subtasks, a Dependency Map, and an **Owned File/Module Scope**. The Owned File/Module Scope is the primary mechanism for preventing file and merge conflicts in parallel development. Acceptance Criteria, Dev Notes, and Testing sections are locked for dev tools.

This is the last planning artifact the plugin produces before handoff.

**Output:** `bmad-output/epics.md`, `bmad-output/stories/*.story.md`

**Prerequisites:** `prd.md`, `architecture.md`

---

<h3 id="bmad-readiness-check">bmad-readiness-check</h3>

Gate check before story compilation begins. Cross-references PRD requirements against architecture coverage and epic completeness. Returns a **PASS / CONCERNS / FAIL** verdict. CONCERNS is addressable; FAIL blocks progression until resolved.

**Output:** `bmad-output/readiness-report-<project-slug>-<date>.md`

**Prerequisites:** `prd.md`, `architecture.md`

---

<h3 id="bmad-sprint-planning">bmad-sprint-planning</h3>

Sequences stories by dependency order and assigns them to parallel waves. Produces `sprint-status.yaml`. No story points, no velocity, no burndown — progress is tracked by story count.

**Output:** `bmad-output/sprint-status.yaml`

**Prerequisites:** `epics.md`, `stories/`

---

<h3 id="bmad-parallel-plan">bmad-parallel-plan</h3>

Builds a dependency DAG and topologically sorts stories into conflict-free concurrent waves. Each wave specifies worktree branch names and merge order so a worktree-based dev runner can execute the wave in parallel without file conflicts.

**Output:** `bmad-output/parallelization-plan.md`

**Prerequisites:** `sprint-status.yaml`

---

<h3 id="bmad-handoff">bmad-handoff</h3>

Emits the final plugin artifact: `handoff-manifest.json`, a stable versioned schema listing each ready story, its owned scope, its wave/parallel-set, and its dependencies. Any external dev tool or autonomous runner can consume this file directly.

**Output:** `bmad-output/handoff-manifest.json`

---

<h3 id="bmad-correct-course">bmad-correct-course</h3>

Mid-stream scope or architecture change handler. Applies minimum-blast-radius re-planning: determines which downstream artifacts are affected and re-runs only those phases. Routes to `bmad-epics-and-stories`, `bmad-sprint-planning`, or `bmad-parallel-plan` as needed. Never re-codes.

---

<h3 id="bmad-investigate">bmad-investigate</h3>

Forensic bug triage. Grades evidence (A/B/C confidence), ranks hypotheses, and produces an investigation case file. Optionally emits a fix story for dev handoff.

**Output:** `bmad-output/investigation-*.md`, optional `stories/*.story.md`

---

<h3 id="bmad-builder">bmad-builder</h3>

Meta-skill for extending the plugin. Scaffolds and validates new planning and orchestration skills. Enforces the scope law — builder skills created here must stay within planning/orchestration and must not generate application code.

---

## Migration Map: Old Slash Commands to Skills

If you used the previous slash-command interface, this table shows the equivalent plugin skill.

| Old slash command | New plugin skill | Notes |
|-------------------|-----------------|-------|
| `/workflow-init` | `bmad-init` | Now includes interactive track selection (Quick Flow / BMad Method / Enterprise) instead of numbered levels |
| `/workflow-status` | `bmad-help` | Same routing function; now reads artifact state rather than a status file |
| `/product-brief` | `bmad-product-brief` | Identical purpose; namespaced |
| `/prd` | `bmad-prd` | Same document shape; no Fibonacci points in output |
| `/tech-spec` | `bmad-tech-spec` | Now Quick Flow track only |
| `/create-ux-design` | `bmad-ux` | Now emits two documents: `DESIGN.md` + `EXPERIENCE.md` |
| `/architecture` | `bmad-architecture` | Now explicitly produces ADRs and an FR/NFR coverage matrix |
| `/solutioning-gate-check` | `bmad-readiness-check` | PASS / CONCERNS / FAIL verdict (same function) |
| `/sprint-planning` | `bmad-sprint-planning` | No points or velocity; count-based, wave-ordered |
| `/create-story` | `bmad-epics-and-stories` | Stories are now compiled context objects with Owned File/Module Scope |
| `/dev-story` | **Not in this plugin** | Implementation is handled by external dev tools consuming `handoff-manifest.json` |
| `/brainstorm` | `bmad-brainstorm` | Namespaced |
| `/research` | `bmad-research` | Namespaced |
| `/create-agent` | `bmad-builder` | Now scoped to planning/orchestration skills only |
| `/create-workflow` | `bmad-builder` | Consolidated into builder |
| *(new)* | `bmad-prfaq` | Working-Backwards PR/FAQ — no prior equivalent |
| *(new)* | `bmad-spec` | Five-field SPEC.md kernel — no prior equivalent |
| *(new)* | `bmad-parallel-plan` | Dependency DAG + wave planning — no prior equivalent |
| *(new)* | `bmad-handoff` | Handoff manifest for dev tools — no prior equivalent |
| *(new)* | `bmad-correct-course` | Mid-stream re-planning — no prior equivalent |
| *(new)* | `bmad-investigate` | Forensic triage — no prior equivalent |
| *(new)* | `bmad-document-project` | Brownfield documentation — no prior equivalent |

---

## Typical Flows by Track

### Quick Flow

```
bmad-init  →  bmad-spec (optional)  →  bmad-tech-spec
          →  bmad-epics-and-stories  →  bmad-handoff
```

### BMad Method

```
bmad-init  →  bmad-product-brief (optional)  →  bmad-prd
          →  bmad-architecture  →  bmad-ux (if UI)
          →  bmad-readiness-check (gate)
          →  bmad-epics-and-stories  →  bmad-sprint-planning
          →  bmad-parallel-plan (optional)  →  bmad-handoff
```

### Enterprise

Everything in BMad Method, plus security and DevOps planning addenda added after `bmad-architecture` and before `bmad-readiness-check`.

---

## Next Steps

- See [getting started](../getting-started) for installation and first-run instructions
- See [subagent patterns](../subagent-patterns) for how parallel planning agents are coordinated
- See [examples](../examples/) for complete end-to-end planning walkthroughs

---

> The **BMAD Method** is created and maintained by the [BMAD Code Organization](https://github.com/bmad-code-org/BMAD-METHOD). This plugin is an independent Claude Code harness for the method's planning and orchestration workflows. No endorsement is implied. All methodology credit belongs to the BMAD Code Organization.
