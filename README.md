# BMAD Planning & Orchestrator — a Claude Code plugin

[![Run in Smithery](https://smithery.ai/badge/skills/aj-geddes)](https://smithery.ai/skills?ns=aj-geddes&utm_source=github&utm_medium=badge)
[![BMAD Method](https://img.shields.io/badge/method-BMAD%20v6.x-orange.svg)](https://github.com/bmad-code-org/BMAD-METHOD)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

> This repository is a **Claude Code plugin marketplace**. It ships one plugin —
> **BMAD Planning & Orchestrator** — that harnesses the **BMAD Method** to
> **plan, document, and orchestrate** software work as conflict-free parallel
> workstreams, then hands implementation off to your dev tools.
>
> **It plans and orchestrates. It does not write the code.**

Documentation site: https://aj-geddes.github.io/claude-code-bmad-skills

---

## 🎯 Attribution & Credit

The **BMAD Method™** (Breakthrough Method for Agile AI-Driven Development) is
created and maintained by the **BMAD Code Organization**. This repository is an
**independent Claude Code harness** for the method — not an official BMAD product,
and no endorsement is implied. **All methodology credit belongs to the BMAD Code
Organization.**

- **Repository:** https://github.com/bmad-code-org/BMAD-METHOD
- **Documentation:** https://docs.bmad-method.org/
- **Website:** https://bmadcodes.com/bmad-method/
- **YouTube:** [@BMadCode](https://www.youtube.com/@BMadCode) · **Discord:** https://discord.gg/gk8jAdXWmj

The methodology, agent roles, workflow patterns, document shapes, and all BMAD
concepts are the intellectual property of the BMAD Code Organization. See
[`bmad-planning-orchestrator/ATTRIBUTION.md`](bmad-planning-orchestrator/ATTRIBUTION.md).

---

## Install

```text
/plugin marketplace add aj-geddes/claude-code-bmad-skills
/plugin install bmad-planning-orchestrator@bmad-method-harness
```

Then `/reload-plugins` (or restart Claude Code). That's it — no installer script,
no `npx`, no copying into `~/.claude`. Updates flow through the marketplace.

**Local development:** `claude --plugin-dir ./bmad-planning-orchestrator`

---

## What you get

The plugin runs the BMAD lifecycle — **Analysis → Planning → Solutioning →
Implementation-handoff** — right-sized by an interactive **track** (Quick Flow /
BMad Method / Enterprise), and stops at a `ready-for-dev` story file plus a
tool-agnostic handoff manifest.

Its signature contribution is **making parallel AI development safe**:

- **One architecture** prevents *semantic* conflicts (API style, data model,
  naming, security) across agents.
- **Stories scoped to disjoint files**, dependency-ordered into parallel
  **waves**, prevent *file/merge* conflicts.
- **`handoff-manifest.json`** lets any dev runner pick up the work.

Full skill catalog, flow diagram, and the handoff contract are in the plugin
README: **[`bmad-planning-orchestrator/README.md`](bmad-planning-orchestrator/README.md)**.

---

## Why a plugin (and why planning-only)?

This project began as a suite of Claude Code *skills* installed by a bash/
PowerShell script. Two things changed:

1. **Claude Code added plugins + marketplaces** — a first-class way to
   distribute and version a bundle of skills, agents, and hooks. We adopted it.
2. **The BMAD Method advanced to a skills-centric v6.x** and the broader
   ecosystem grew capable dev tools. So we refocused: BMAD does what it is best
   at — **planning and orchestration** — and lets specialized tools do the
   coding. The `developer`/`dev-story`/lint/coverage pieces were removed.

If you used the old skills install, see [MIGRATION.md](MIGRATION.md).

---

## Repository layout

```
claude-code-bmad-skills/
├── .claude-plugin/
│   └── marketplace.json          # the marketplace (one plugin)
├── bmad-planning-orchestrator/   # ← the plugin
│   ├── .claude-plugin/plugin.json
│   ├── skills/                   # 20 planning/orchestration skills
│   ├── agents/                   # planning subagents
│   ├── hooks/                    # next-step nudges
│   ├── scripts/  resources/      # shared utils + guides
│   ├── README.md  ATTRIBUTION.md  LICENSE  CHANGELOG.md
├── docs/                         # GitHub Pages site
├── CLAUDE.md  CONTRIBUTING.md  MIGRATION.md  LICENSE
```

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). The one rule that defines this project:
**every contribution stays on the planning/orchestration side of the line —
nothing here writes, runs, tests, or reviews application code.**

## License

MIT — see [LICENSE](LICENSE). The BMAD Method™ name and methodology belong to the
BMAD Code Organization; this license covers only the Claude Code plugin
implementation.
