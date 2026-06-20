---
layout: default
title: "Skills"
description: "Complete reference for all 20 BMAD Planning & Orchestrator plugin skills. Learn what each skill does, when it runs, and how they sequence through Analysis, Planning, Solutioning, and Orchestration phases."
keywords: "BMAD skills, Claude Code plugin, planning orchestrator, AI planning, product requirements, architecture, sprint planning, handoff manifest"
---

# BMAD Planning & Orchestrator — Skill Catalog

> **Attribution:** The **BMAD Method™** (Breakthrough Method for Agile AI-Driven Development) is created and maintained by the **[BMAD Code Organization](https://github.com/bmad-code-org/BMAD-METHOD)**. This plugin is an independent Claude Code harness for the method's planning and orchestration workflows — not an official BMAD product, and no endorsement is implied. All methodology credit belongs to the BMAD Code Organization. See [bmad-code-org/BMAD-METHOD](https://github.com/bmad-code-org/BMAD-METHOD) · [docs.bmad-method.org](https://docs.bmad-method.org/) · [bmadcodes.com](https://bmadcodes.com/bmad-method/).

---

The **bmad-planning-orchestrator** plugin ships **20 skills** that plan, orchestrate, and hand off — and nothing else. It never writes code, runs tests, lints, checks coverage, or reviews diffs. The last artifact it produces is a `ready-for-dev` story file plus a `handoff-manifest.json` consumed by your external dev tool.

Skills are namespaced `/bmad-planning-orchestrator:<skill>` and most are auto-invoked by Claude based on context.

---

## Install

```text
/plugin marketplace add aj-geddes/claude-code-bmad-skills
/plugin install bmad-planning-orchestrator@bmad-method-harness
```

Then `/reload-plugins` (or restart Claude Code).

Local development / testing:

```text
claude --plugin-dir ./bmad-planning-orchestrator
```

---

## Tracks (right-sizing)

The plugin scales through three interactive **tracks** selected at `bmad-init` time:

| Track | Scope | Planning it runs |
|-------|-------|------------------|
| **Quick Flow** | 1–15 stories | tech-spec only |
| **BMad Method** | 10–50+ stories | PRD + Architecture (+ optional UX) |
| **Enterprise** | 30+ stories | PRD + Architecture + Security + DevOps addenda |

Sizing uses **one-dev-day decomposition and count-based delivery** — no Fibonacci points, no velocity, no burndown.

---

## The flow

```
bmad-init ──▶ select track, scaffold workspace + decision-log + project-context
    │
ANALYSIS (optional)   brainstorm · research · product-brief · prfaq · spec
    │
PLANNING              prd  (or tech-spec for Quick Flow)
    │
SOLUTIONING           ux (if UI) · architecture · epics-and-stories · readiness-check
    │                                             └── "Planning Ends Here"
ORCHESTRATION         sprint-planning · parallel-plan · handoff
    │
    ▼   ready-for-dev story files + handoff-manifest.json  ──▶  YOUR DEV TOOL
```

`bmad-help` is the spine: at any point it reads your artifact state and tells you which skill to run next.

---

## Skill catalog

### Spine

These two skills are always present regardless of track.

| Skill | What it does | When to use it |
|-------|-------------|----------------|
| **bmad-help** | "What do I run next?" router — scans the output folder, infers the current phase and track, and recommends the next skill; produces no documents itself | Start of any session, or whenever you ask "what's next?", "where am I?", "continue", "resume planning" |
| **bmad-init** | Interactive track selection; scaffolds the output folder, `config`, `decision-log.md`, and `project-context.md` "constitution" | First skill to run on any new project before any other planning work |

---

### Analysis

Analysis is always **optional** — run as many or as few of these as your project needs.

| Skill | What it does | When to use it |
|-------|-------------|----------------|
| **bmad-brainstorm** | Structured ideation using SCAMPER, SWOT, 5 Whys, Mind Mapping, Six Thinking Hats, Reverse Brainstorming, Starbursting, and Brainwriting; produces `brainstorming-report.md` | "Brainstorm", "ideate", "explore options", "SCAMPER", "let's think through possibilities" |
| **bmad-research** | Market, competitive, domain, and technical research using live web sources; produces a cited `research-report.md` | "Research [topic]", "competitive analysis", "market size", "evaluate [technology]", "I need research before we plan" |
| **bmad-product-brief** | Guided discovery conversation that captures problem statement, target users, core features, goals, constraints, and success metrics; produces `product-brief.md`; supports Create / Update / Validate | "Create a product brief", "run discovery", "help me define my product", "what problem are we solving?" |
| **bmad-prfaq** | Amazon Working-Backwards press release plus internal and external FAQs that stress-test the concept before building begins; produces `prfaq.md`; supports Create / Update / Validate | "Write a PRFAQ", "working backwards", "press release", "stress-test the concept", "validate the idea before building" |
| **bmad-spec** | Distills any messy input (brain dump, transcript, long PRD, stakeholder notes) into a tight five-field `SPEC.md` kernel: Problem, Capabilities, Constraints, Non-Goals, Success Metrics | "Create a spec", "I have a brain dump", "turn this into something structured", "help me scope this", "what are we actually solving?" |

---

### Planning

| Skill | What it does | When to use it |
|-------|-------------|----------------|
| **bmad-prd** | PRD facilitator — authors `prd.md` with functional requirements (FR-###), non-functional requirements (NFR-###), an epics outline, user stories, acceptance criteria, and MoSCoW/RICE prioritization; also emits `addendum.md` and appends to `decision-log.md`; supports Create / Update / Validate | "Create a PRD", "write requirements", "define FRs/NFRs", "break this into epics", "prioritize features", "validate my PRD" — **BMad Method and Enterprise tracks** |
| **bmad-tech-spec** | Lightweight technical specification for small-scope work; the single planning artifact before story creation on the Quick Flow track; produces `tech-spec.md`; supports Create / Update / Validate | "Write a tech spec", "quick spec", "small project spec", "we don't need a full PRD" — **Quick Flow track only (1–15 stories)** |

---

### Solutioning

| Skill | What it does | When to use it |
|-------|-------------|----------------|
| **bmad-ux** | Optional UX planning skill; produces two documents: `DESIGN.md` (design tokens, color palette, typography, component specs, WCAG 2.1 AA contract) and `EXPERIENCE.md` (user journeys, flow diagrams, screen states, error/empty/loading handling); supports Create / Update / Validate | "Design the UX", "define the design system", "map user flows", "wireframe the flows", "WCAG compliance", "design tokens" — activate when the project has a UI |
| **bmad-architecture** | Produces `architecture.md` with Architecture Decision Records (ADRs) and systematic NFR coverage, mapping every FR/NFR to a concrete design decision; the semantic-conflict-prevention layer that forces all future parallel dev agents to share API style, data model, naming, and security approach; supports Create / Update / Validate | "Design the architecture", "solutioning", "tech stack", "system design", "ADR", "NFR coverage" — after a PRD is done |
| **bmad-epics-and-stories** | Shards a PRD and architecture into `epics.md` and individual `{epic}.{story}.{slug}.story.md` compiled-context story objects; each story is a self-contained ~8K-token object with source-cited Dev Notes, Acceptance Criteria, Tasks/Subtasks, Testing strategy, Dependency Map, and explicit Owned File/Module Scope; sized to one dev-day; no story points; supports Create / Update / Validate | "Shard the PRD", "create epics", "break the PRD into stories", "create story files", "prepare stories for dev", "mark story ready-for-dev" |
| **bmad-readiness-check** | Solutioning gate — cross-references PRD (or tech-spec), architecture, and epics/stories for coverage consistency and missing pieces; returns PASS / CONCERNS / FAIL with specifics | "Check if we're ready to build", "validate planning", "gate check", "is the architecture complete?", "sign off on planning" |

---

### Orchestration & handoff

| Skill | What it does | When to use it |
|-------|-------------|----------------|
| **bmad-sprint-planning** | Emits and maintains `sprint-status.yaml` — orders stories by epic then dependency, assigns parallel-set (wave) membership, and drives the status lifecycle (backlog → ready-for-dev → in-progress → review → done); sequencing only, no velocity or burndown | "Sequence the stories", "build sprint status", "plan the waves", "assign parallel sets", "order stories by dependency", "prepare for dev handoff" |
| **bmad-parallel-plan** | Builds a dependency DAG from epic order, per-story dependency maps, and Owned File/Module Scope overlaps; topologically sorts into conflict-free concurrent waves capped by `maxParallel`; emits `parallelization-plan.md` with per-story git-worktree branch names and ordered merge sequence | "Plan parallel work", "which stories can run in parallel", "build the wave plan", "conflict-free workstreams", "split into worktrees", "dependency graph" |
| **bmad-handoff** | Emits tool-agnostic `handoff-manifest.json` listing all ready-for-dev stories with id, story file path, status, owned file/module scope, wave/parallel_set, dependencies, acceptance-criteria summary, locked-sections note, and schemaVersion | "Generate a handoff", "create handoff manifest", "export stories for dev", "hand off to dev tool", "prepare handoff for external tool" |

---

### Cross-phase & meta

These skills can run at any phase.

| Skill | What it does | When to use it |
|-------|-------------|----------------|
| **bmad-correct-course** | Mid-stream scope correction — re-enters planning when requirements, features, architecture, or constraints change; re-shards affected epics/stories, re-sequences `sprint-status.yaml`, appends rationale to `decision-log.md`; changes the plan, never the code | "We need to change course", "scope has changed", "new requirement came in", "we're dropping feature X", "correct course", "re-plan after the change" |
| **bmad-investigate** | Forensic bug and issue triage — produces a graded investigation case file: symptoms, evidence graded A/B/C by confidence, ranked hypotheses, suspected components, and a recommended planning response; investigates and documents only; hands off as a story | "Investigate this bug", "triage this issue", "what's causing [symptom]", "root cause this", "create an investigation case file", "forensic analysis" |
| **bmad-document-project** | Brownfield planning input — scans an existing codebase read-only and writes `project-documentation.md` (ground truth for stack, structure, key flows, conventions, and integration points) so downstream planning skills start from reality; does not modify code | "Document this codebase", "brownfield planning", "we have existing code, start planning", "capture the current architecture", "understand the existing system before planning" |
| **bmad-builder** | Meta-skill for scaffolding and validating custom planning/orchestration skills within this plugin; produces the full skill directory (SKILL.md, scripts, templates) pre-targeted at this plugin's path conventions; includes a scope-violation checker so new skills never drift into dev/lint/build territory; supports Create / Validate / Scaffold | "Create a skill", "scaffold a skill", "add a planning skill to the orchestrator", "validate this skill", "check this skill for scope violations" |

---

## The handoff contract

A story file is marked `status: ready-for-dev` and carries everything an implementer needs:

- Source-cited Dev Notes (back-linked to `prd.md` / `architecture.md`)
- Acceptance Criteria
- Tasks/Subtasks mapped to ACs
- Testing strategy (planning artifact only — not executed by this plugin)
- Dependency Map
- Explicit **Owned File/Module Scope** (the lever for conflict-free parallel scheduling)

Acceptance Criteria, Dev Notes, and Testing are **locked** — your dev tool implements against them but must not edit them.

`bmad-handoff` emits `handoff-manifest.json` (stable, versioned schema) listing each ready story, its scope, its wave/parallel-set, and its dependencies so any worktree-based or autonomous runner can pick up the work.

---

## What this plugin does NOT do

- No code generation
- No running tests, linting, coverage checks, or build steps
- No reviewing implemented diffs

Implementation is your external dev tool's job. This plugin's boundary is the `ready-for-dev` story file and `handoff-manifest.json`.

---

## Next steps

- [Getting Started](../getting-started/) — first run walkthrough
- [Commands](../commands/) — full command reference per skill
- [Examples](../examples/) — complete workflow walkthroughs
- [Subagent Patterns](../subagent-patterns) — how planning fan-out works internally

---

*BMAD Method™ is a trademark of the BMAD Code Organization. This plugin is an independent, community-built integration.*
