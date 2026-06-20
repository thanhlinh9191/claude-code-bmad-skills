# BMAD Planning & Orchestrator

> A Claude Code **plugin** that harnesses the **BMAD Method** for planning,
> roadmapping, and conflict-free parallel orchestration — then hands the work
> off to your dev tools. **It plans and orchestrates. It never writes the code.**

[![BMAD Method](https://img.shields.io/badge/method-BMAD%20v6.x-orange.svg)](https://github.com/bmad-code-org/BMAD-METHOD)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

---

## Attribution

The **BMAD Method™** (Breakthrough Method for Agile AI-Driven Development) is
created and maintained by the **[BMAD Code Organization](https://github.com/bmad-code-org/BMAD-METHOD)**.
This plugin is an **independent Claude Code harness** for the method's planning
and orchestration workflows — not an official BMAD product, and no endorsement
is implied. **All methodology credit belongs to the BMAD Code Organization.**
See [ATTRIBUTION.md](ATTRIBUTION.md).

- Method: https://github.com/bmad-code-org/BMAD-METHOD · Docs: https://docs.bmad-method.org/ · Site: https://bmadcodes.com/bmad-method/

---

## Why this exists

Modern coding harnesses (Claude Code, and a growing ecosystem of dev plugins)
are very good at **writing code**. They are much weaker at the part that
actually determines whether parallel AI development succeeds: **planning the
work so that many agents can build at once without colliding.**

That is exactly what the BMAD Method is good at. This plugin focuses BMAD on its
strongest contribution — **upstream planning and orchestration** — and
deliberately stops at the handoff. It produces the artifacts that let *other*
tools do the dev work fast, in parallel, and without conflicts:

- One **architecture** so every agent shares API style, data model, naming, and
  security approach — preventing the *semantic* conflicts that turn parallel
  work into an integration nightmare. (Catching alignment in solutioning is
  ~10× cheaper than discovering it mid-build.)
- **Stories scoped to disjoint files**, dependency-ordered, grouped into
  parallel **waves** — preventing the *file/merge* conflicts that serialize
  teams.
- A **tool-agnostic handoff manifest** any dev runner can consume.

## What it does NOT do

No code generation. No running tests, linting, or coverage. No reviewing
implemented diffs. The last thing it produces is a **`ready-for-dev` story
file** (and a handoff manifest). Implementation is your dev tool's job.

---

## Install

```text
/plugin marketplace add aj-geddes/claude-code-bmad-skills
/plugin install bmad-planning-orchestrator@bmad-method-harness
```

Then `/reload-plugins` (or restart Claude Code). Skills are namespaced
`/bmad-planning-orchestrator:<skill>` and most are auto-invoked by Claude based
on what you're doing.

> **Note:** the marketplace manifest lives at the **repository root**
> (`.claude-plugin/marketplace.json`), so `marketplace add` targets the whole
> repo — not this `bmad-planning-orchestrator/` subdirectory. Add the repo, then
> install the plugin from it.

Local development / testing:

```text
claude --plugin-dir ./bmad-planning-orchestrator
```

Configure at enable time (`userConfig`): output folder (default `bmad-output/`),
default track, and max parallel workstreams.

---

## The flow

BMAD's four phases — **Analysis → Planning → Solutioning → Implementation** —
right-sized by an interactive **track**:

| Track | Scope | Planning it runs |
|-------|-------|------------------|
| **Quick Flow** | 1–15 stories | tech-spec only |
| **BMad Method** | 10–50+ stories | PRD + Architecture (+ optional UX) |
| **Enterprise** | 30+ stories | PRD + Architecture + Security + DevOps |

```
bmad-init ──▶ select track, create workspace + decision-log + project-context
    │
ANALYSIS (optional)   brainstorm · research · product-brief · prfaq · spec
    │
PLANNING              prd  (or tech-spec for Quick Flow)
    │
SOLUTIONING           ux (if UI) · architecture · epics-and-stories · readiness-check
    │                                                   └── "Planning Ends Here"
ORCHESTRATION         sprint-planning · parallel-plan · handoff
    │
    ▼   ready-for-dev story files + handoff-manifest.json  ──▶  YOUR DEV TOOL
```

`bmad-help` is the spine: at any point it reads your artifact state and tells
you which skill to run next.

---

## Skill catalog (20 skills)

**Orchestration spine**
- `bmad-help` — “what do I run next?” router; skips optional phases
- `bmad-init` — interactive track selection; scaffolds workspace, `decision-log.md`, `project-context.md`

**Analysis**
- `bmad-brainstorm` — structured ideation (SCAMPER, SWOT, 5 Whys, …)
- `bmad-research` — market / domain / technical research (web-sourced, cited)
- `bmad-product-brief` — product brief *(Create / Update / Validate)*
- `bmad-prfaq` — Working-Backwards press release + FAQ
- `bmad-spec` — five-field `SPEC.md` kernel (problem, capabilities, constraints, non-goals, success metrics)

**Planning**
- `bmad-prd` — PRD with FRs/NFRs, epics, MoSCoW *(Create / Update / Validate)*; emits `prd.md` + `addendum.md` + `decision-log.md`
- `bmad-tech-spec` — lightweight tech spec (Quick Flow track)

**Solutioning**
- `bmad-ux` — two-document UX contract: `DESIGN.md` (tokens, WCAG AA) + `EXPERIENCE.md` (journeys)
- `bmad-architecture` — `architecture.md` + ADRs; systematic NFR coverage; **semantic-conflict prevention**
- `bmad-epics-and-stories` — shards into epics + `{epic}.{story}.{slug}.story.md` compiled-context stories with **owned-file scope**
- `bmad-readiness-check` — PASS / CONCERNS / FAIL gate before handoff

**Orchestration & handoff**
- `bmad-sprint-planning` — `sprint-status.yaml` roadmap (sequencing only — no points/velocity/burndown)
- `bmad-parallel-plan` — dependency DAG → conflict-free **waves** with worktree branches + merge order
- `bmad-handoff` — tool-agnostic `handoff-manifest.json` for external dev runners

**Cross-phase & meta**
- `bmad-correct-course` — mid-stream scope change → re-plan (never re-code)
- `bmad-investigate` — forensic, evidence-graded triage → a story to hand off
- `bmad-document-project` — brownfield current-state docs (read-only)
- `bmad-builder` — scaffold/validate custom **planning** skills

Plus **planning subagents** (`story-author`, `epic-scoper`, `readiness-auditor`)
for fan-out, and hooks that nudge you to the next step.

---

## The handoff contract

A story file is marked `status: ready-for-dev` and carries everything an
implementer needs: source-cited Dev Notes, Acceptance Criteria, a Testing
*strategy*, Tasks/Subtasks, a Dependency Map, and an explicit **Owned File/Module
Scope**. Acceptance Criteria, Dev Notes, and Testing are **locked** — your dev
tool implements against them but must not edit them.

`bmad-handoff` emits `handoff-manifest.json` (a stable, versioned schema)
listing each ready story, its scope, its wave/parallel-set, and its
dependencies — so any worktree-based or autonomous runner can pick up the work.

See [`resources/bmad-method-mapping.md`](resources/bmad-method-mapping.md) for
how each skill maps to its upstream BMAD counterpart.

---

*BMAD Method™ is a trademark of the BMAD Code Organization. This is an
independent, community-built integration.*
