---
layout: default
title: "BMAD Planning & Orchestrator - Claude Code Plugin"
description: "A Claude Code plugin that harnesses the BMAD Method for planning, roadmapping, and conflict-free parallel orchestration — then hands work off to your dev tools. It plans and orchestrates. It never writes code."
keywords: "Claude Code, BMAD Method, agile planning, AI orchestration, parallel development, Claude plugin, sprint planning, story handoff"
---

<div class="hero-section" markdown="1">

# BMAD Planning & Orchestrator

<p class="hero-subtitle">A Claude Code plugin that plans and orchestrates. It never writes the code.</p>

<div class="badges">
<a href="https://github.com/aj-geddes/claude-code-bmad-skills/releases"><img src="https://img.shields.io/badge/plugin-bmad--planning--orchestrator-orange.svg" alt="Plugin" /></a>
<a href="https://github.com/bmad-code-org/BMAD-METHOD"><img src="https://img.shields.io/badge/method-BMAD%20v6.x-blue.svg" alt="BMAD Method v6.x" /></a>
<a href="https://github.com/aj-geddes/claude-code-bmad-skills/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-green.svg" alt="License" /></a>
</div>

</div>

---

## Attribution

<div class="attribution-box" markdown="1">

The **BMAD Method™** (Breakthrough Method for Agile AI-Driven Development) is created and maintained by the **[BMAD Code Organization](https://github.com/bmad-code-org/BMAD-METHOD)**. All methodology credit — the four-phase lifecycle, agent roles, document shapes, scale-adaptive tracks, and every concept this plugin builds on — belongs to the BMAD Code Organization.

This plugin is an **independent Claude Code harness** for BMAD's planning and orchestration workflows. It is not an official BMAD product and no endorsement is implied. We are only the packaging.

**Original BMAD Method:** [github.com/bmad-code-org/BMAD-METHOD](https://github.com/bmad-code-org/BMAD-METHOD) · [docs.bmad-method.org](https://docs.bmad-method.org/) · [bmadcodes.com](https://bmadcodes.com/bmad-method/)

</div>

---

## What this plugin is

Modern coding harnesses are good at **writing code**. They are much weaker at the part that actually determines whether parallel AI development succeeds: **planning the work so that many agents can build at once without colliding.**

That is exactly what the BMAD Method is good at. This plugin focuses BMAD squarely on its strongest contribution — **upstream planning and orchestration** — and deliberately stops at the handoff.

It produces the artifacts that let other tools do the dev work fast, in parallel, and without conflicts:

- One **architecture** so every agent shares API style, data model, naming, and security approach — preventing semantic conflicts that turn parallel work into an integration nightmare. (Catching alignment in solutioning is roughly 10x cheaper than discovering it mid-build.)
- **Stories scoped to disjoint files**, dependency-ordered, grouped into parallel **waves** — preventing file/merge conflicts that serialize teams.
- A **tool-agnostic `handoff-manifest.json`** any dev runner can consume.

### What it does NOT do

No code generation. No running tests, linting, or coverage checks. No reviewing implemented diffs. The last artifact this plugin produces is a `ready-for-dev` story file and the handoff manifest. Implementation is your dev tool's job.

---

## Install

From the Claude Code plugin marketplace:

```
/plugin marketplace add aj-geddes/claude-code-bmad-skills
/plugin install bmad-planning-orchestrator@bmad-method-harness
/reload-plugins
```

Skills are namespaced `/bmad-planning-orchestrator:<skill>` and most auto-invoke based on what you are doing.

For local development and testing:

```
claude --plugin-dir ./bmad-planning-orchestrator
```

---

## The planning thesis

This plugin exists because **planning is the multiplier**. When the upstream work is done well — a shared architecture, stories scoped to owned files, a dependency-ordered wave plan — an AI dev tool can fan out across many parallel workstreams with no coordination overhead. When the upstream work is skipped, parallel dev produces collisions, rework, and integration pain.

The BMAD Method provides exactly the planning discipline that makes parallel AI development reliable. This plugin harnesses it.

---

## The flow

BMAD's four phases, right-sized by an interactive **track** selection at init time:

| Track | Scope | Planning phases |
|-------|-------|-----------------|
| **Quick Flow** | 1-15 stories | Tech-spec only |
| **BMad Method** | 10-50+ stories | PRD + Architecture (+ optional UX) |
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
    ▼
ready-for-dev story files + handoff-manifest.json  ──▶  YOUR DEV TOOL
```

`bmad-help` is the spine: at any point it reads your artifact state and tells you which skill to run next. Sizing is one-dev-day story decomposition and count-based delivery — no Fibonacci points, no velocity, no burndown.

---

## Skills overview

The plugin ships **20 skills** across four groups:

**Orchestration spine**

| Skill | What it does |
|-------|--------------|
| `bmad-help` | "What do I run next?" router; reads artifact state, skips optional phases |
| `bmad-init` | Interactive track selection; scaffolds workspace, `decision-log.md`, `project-context.md` |

**Analysis** (all optional — enter at any point)

| Skill | What it does |
|-------|--------------|
| `bmad-brainstorm` | Structured ideation (SCAMPER, SWOT, 5 Whys, and more) |
| `bmad-research` | Market, domain, and technical research — web-sourced and cited |
| `bmad-product-brief` | Product brief — Create / Update / Validate |
| `bmad-prfaq` | Working-Backwards press release + FAQ |
| `bmad-spec` | Five-field `SPEC.md` kernel (problem, capabilities, constraints, non-goals, success metrics) |

**Planning**

| Skill | What it does |
|-------|--------------|
| `bmad-prd` | PRD with FRs/NFRs, epics, MoSCoW — Create / Update / Validate; emits `prd.md` + `addendum.md` + `decision-log.md` |
| `bmad-tech-spec` | Lightweight tech spec (Quick Flow track) |

**Solutioning**

| Skill | What it does |
|-------|--------------|
| `bmad-ux` | Two-document UX contract: `DESIGN.md` (tokens, WCAG AA) + `EXPERIENCE.md` (journeys) |
| `bmad-architecture` | `architecture.md` + ADRs; systematic NFR coverage; semantic-conflict prevention |
| `bmad-epics-and-stories` | Shards into epics + `{epic}.{story}.{slug}.story.md` compiled-context stories with owned-file scope |
| `bmad-readiness-check` | PASS / CONCERNS / FAIL gate before handoff |

**Orchestration and handoff**

| Skill | What it does |
|-------|--------------|
| `bmad-sprint-planning` | `sprint-status.yaml` roadmap — sequencing only, no points or velocity |
| `bmad-parallel-plan` | Dependency DAG → conflict-free waves with worktree branches and merge order |
| `bmad-handoff` | Tool-agnostic `handoff-manifest.json` for external dev runners |

**Cross-phase and meta**

| Skill | What it does |
|-------|--------------|
| `bmad-correct-course` | Mid-stream scope change → re-plan (never re-code) |
| `bmad-investigate` | Forensic, evidence-graded triage → a story to hand off |
| `bmad-document-project` | Brownfield current-state docs (read-only) |
| `bmad-builder` | Scaffold and validate custom planning skills |

---

## Documentation

<div class="docs-grid">

<div class="docs-card">
<h3><a href="./getting-started">Getting Started</a></h3>
<p>Install the plugin, run your first bmad-init, and walk through a Quick Flow project end to end.</p>
</div>

<div class="docs-card">
<h3><a href="./skills/">Skills Reference</a></h3>
<p>Detailed documentation for all 20 skills: triggers, inputs, outputs, and what each skill produces.</p>
</div>

<div class="docs-card">
<h3><a href="./examples/">Examples</a></h3>
<p>Walkthroughs of the three tracks — Quick Flow, BMad Method, and Enterprise — with real artifact samples.</p>
</div>

<div class="docs-card">
<h3><a href="./subagent-patterns">Subagent Patterns</a></h3>
<p>How the plugin fans out planning work across parallel subagents and coordinates the results.</p>
</div>

<div class="docs-card">
<h3><a href="./configuration">Configuration</a></h3>
<p>userConfig options: output folder, default track, and max parallel workstreams.</p>
</div>

<div class="docs-card">
<h3><a href="./troubleshooting">Troubleshooting</a></h3>
<p>Common issues and solutions.</p>
</div>

</div>

---

## Community and support

- **GitHub Issues:** [Report bugs or request features](https://github.com/aj-geddes/claude-code-bmad-skills/issues)
- **BMAD Method (upstream):** [github.com/bmad-code-org/BMAD-METHOD](https://github.com/bmad-code-org/BMAD-METHOD)
- **BMAD Discord:** [discord.gg/gk8jAdXWmj](https://discord.gg/gk8jAdXWmj)
- **License:** MIT

---

<div class="cta-section">
<p>Ready to plan work that parallel agents can actually execute?</p>
<a href="./getting-started">Get Started</a>
</div>
