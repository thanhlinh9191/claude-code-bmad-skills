# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

This repo is a **Claude Code plugin marketplace** shipping a single plugin,
**BMAD Planning & Orchestrator** — a harness for the [BMAD Method](https://github.com/bmad-code-org/BMAD-METHOD)
focused on **planning and orchestration only**. There is no application to build
or run. The "product" is Markdown skills + a few shell/Python helper scripts +
document templates, distributed as a plugin and installed from the marketplace.

## The one rule that defines this project

**This plugin plans and orchestrates work; it never implements it.** No skill,
agent, hook, or script here may write application code, run tests, lint, check
coverage, build, or review an implemented diff. The last artifact the plugin
produces is a `ready-for-dev` story file (plus a handoff manifest); a separate
dev tool does the coding. When editing or adding anything, if it starts to
*execute* development rather than *plan* it, it's out of scope — plan it and hand
it off instead. This is the line reviewers must protect (`bmad-builder`'s
`validate-skill.sh` flags scope leaks automatically).

## Architecture: marketplace → plugin → skills

```
.claude-plugin/marketplace.json          # marketplace "bmad-method-harness", one plugin entry → ./bmad-planning-orchestrator
bmad-planning-orchestrator/
├── .claude-plugin/plugin.json           # manifest: name, version, userConfig, hooks path
├── skills/<skill>/SKILL.md              # 20 auto-discovered, model-invoked skills (+ REFERENCE.md, scripts/, templates/)
├── agents/*.md                          # planning subagents (story-author, epic-scoper, readiness-auditor)
├── hooks/hooks.json + scripts/          # SessionStart context load + Stop "next step" nudge
├── scripts/*                            # SHARED utils referenced by skills via ${CLAUDE_PLUGIN_ROOT}
└── resources/*.md                       # guides + bmad-method-mapping.md (skill→upstream credit)
```

- **Skills are the primitive.** Mirroring current BMAD (v6.1+), everything is a
  skill with a `SKILL.md` entrypoint. Skills are namespaced
  `/bmad-planning-orchestrator:<skill>` and mostly auto-invoke based on their
  `description` trigger phrases.
- **`bmad-help` + `bmad-init` are the spine.** `bmad-init` selects a track and
  scaffolds the workspace; `bmad-help` reads artifact state and routes to the
  next skill. The hooks fire a lightweight next-step nudge.
- **Phases:** Analysis → Planning → Solutioning → Implementation-handoff. The
  plugin owns everything up to and including story creation
  (`bmad-epics-and-stories`) and the orchestration seam (`bmad-sprint-planning`,
  `bmad-parallel-plan`, `bmad-handoff`). `bmad-readiness-check` is the literal
  "Planning Ends Here" gate.
- **Parallel-safety is an upstream planning product** (the project's whole
  thesis): `bmad-architecture` prevents *semantic* conflicts; story **Owned
  File/Module Scope** + `scripts/scope-conflict-check.sh` prevent *file/merge*
  conflicts; `bmad-parallel-plan` topo-sorts stories into disjoint **waves**.
  Understanding this requires reading `bmad-architecture`,
  `bmad-epics-and-stories`, and `bmad-parallel-plan` together.

## Conventions that are easy to get wrong

- **Tracks, not Levels.** Right-size with Quick Flow / BMad Method / Enterprise.
  There are no numbered project Levels 0–4 (that was the old model).
- **No story points.** Sizing is "small enough for one agent session" (~one
  dev-day); delivery is count-based (stories remaining ÷ completion rate). There
  is deliberately no Fibonacci/velocity/burndown anywhere.
- **`${CLAUDE_PLUGIN_ROOT}` for every bundled path.** Plugins are copied to a
  cache on install, so never hardcode `~/.claude` or absolute paths, and never
  use `../` to escape the plugin root. Double-quote the variable in hook commands.
- **Story file shape is a contract.** `{epic}.{story}.{slug}.story.md` with
  source-cited Dev Notes, Owned File/Module Scope, and **locked** Acceptance
  Criteria / Dev Notes / Testing. The `handoff-manifest.json` schema is a stable
  versioned interface — bump `schemaVersion` on change.
- **SKILL.md ≤ ~5K tokens**, overflow into `REFERENCE.md`. Every `SKILL.md` ends
  with the BMAD attribution footer.

## Commands

```bash
# Validate a SKILL.md (frontmatter + scope-leak check)
./bmad-planning-orchestrator/skills/bmad-builder/scripts/validate-skill.sh <path-to-SKILL.md>

# Scaffold a new planning skill
./bmad-planning-orchestrator/skills/bmad-builder/scripts/scaffold-skill.sh <new-skill-name>

# Make scripts executable after creating/editing them
find bmad-planning-orchestrator -name "*.sh" -o -name "*.py" | xargs chmod +x

# Validate the manifests parse
python3 -m json.tool .claude-plugin/marketplace.json >/dev/null && \
python3 -m json.tool bmad-planning-orchestrator/.claude-plugin/plugin.json >/dev/null && echo OK

# Test the plugin locally without installing
claude --plugin-dir ./bmad-planning-orchestrator
```

There is no compiler/linter/test-runner for the repo itself. "Does it work" =
manifests parse, `validate-skill.sh` passes on every `SKILL.md`, scripts are
executable, templates keep their `{{placeholders}}`, and **no scope leaks**.

## Distribution

Install is marketplace-only (`/plugin marketplace add` → `/plugin install`).
There are no `install-v6.sh/ps1` scripts anymore. Version is pinned in
`plugin.json` (bump it to ship updates) and the CHANGELOG records which upstream
BMAD v6.x the release tracks.

## Attribution (non-negotiable)

The BMAD Method™ and all its concepts belong to the **BMAD Code Organization**
(https://github.com/bmad-code-org/BMAD-METHOD). Preserve the LICENSE attribution
clause verbatim, the per-`SKILL.md` footer, `ATTRIBUTION.md`, and the upstream
links in the manifest when editing those files. `resources/bmad-method-mapping.md`
records the skill→upstream mapping; keep it current.
