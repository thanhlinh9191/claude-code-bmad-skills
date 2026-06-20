# Contributing

Thanks for helping improve the **BMAD Planning & Orchestrator** plugin. Please
keep the credit where it belongs: the **BMAD Method™** is the work of the
**[BMAD Code Organization](https://github.com/bmad-code-org/BMAD-METHOD)**; this
repo is only a Claude Code harness for it. Do not remove or weaken attribution,
and don't alter the BMAD methodology itself — coordinate upstream for that.

## The line you must not cross

**This plugin plans and orchestrates work. It never implements it.**

A contribution is in scope if it helps *plan, document, sequence, or hand off*
work. It is **out of scope** the moment it tries to *write application code, run
tests, lint, check coverage, build, or review an implemented diff*. The furthest
the plugin goes is producing a `ready-for-dev` story file and a handoff manifest.

`bmad-builder`'s `validate-skill.sh` flags scope-leak language; a PR that
introduces code execution will be rejected even if it "works."

## Adding or editing a skill

Skills live in `bmad-planning-orchestrator/skills/<name>/`.

1. Scaffold: `./bmad-planning-orchestrator/skills/bmad-builder/scripts/scaffold-skill.sh <name>`
2. `SKILL.md` rules:
   - YAML frontmatter: `name` (== directory), `description` (≤1024 chars, with
     concrete "use when…" trigger phrases), `allowed-tools` (planning tools only).
   - Body ≤ ~5K tokens; put long reference detail in `REFERENCE.md`.
   - Use `${CLAUDE_PLUGIN_ROOT}` for every bundled path; never hardcode
     `~/.claude` or absolute paths; never `../` out of the plugin root.
   - End with the BMAD attribution footer (see any existing skill).
3. Follow BMAD fidelity: **tracks** not Levels (Quick Flow / BMad Method /
   Enterprise); **no story points / velocity / burndown** (one-dev-day sizing,
   count-based delivery); three-intent (Create/Update/Validate) where it fits;
   the story-file contract (locked AC/Dev Notes/Testing, Owned File/Module Scope,
   source-cited Dev Notes).
4. If the skill maps to an upstream BMAD skill, add the row to
   `bmad-planning-orchestrator/resources/bmad-method-mapping.md`.

## Before you open a PR

```bash
# Frontmatter + scope-leak check on every skill
find bmad-planning-orchestrator/skills -name SKILL.md \
  -exec ./bmad-planning-orchestrator/skills/bmad-builder/scripts/validate-skill.sh {} \;

# Manifests parse
python3 -m json.tool .claude-plugin/marketplace.json >/dev/null
python3 -m json.tool bmad-planning-orchestrator/.claude-plugin/plugin.json >/dev/null

# Scripts executable
find bmad-planning-orchestrator -name "*.sh" -o -name "*.py" | xargs chmod +x

# Smoke-test locally
claude --plugin-dir ./bmad-planning-orchestrator
```

Bump `version` in `plugin.json` for user-visible changes and add a `CHANGELOG`
entry noting which upstream BMAD v6.x the change tracks.

## Good contributions

- New or improved **planning/orchestration** skills (e.g. better elicitation,
  new planning document shapes from upstream BMAD).
- Better track right-sizing, dependency/parallel-wave planning, handoff-manifest
  adapters for more dev runners.
- Documentation, examples, and keeping `bmad-method-mapping.md` in sync with
  upstream BMAD v6.x.

## Style

Functional and direct. Persona names (Mary/John/Winston/Sally) are fine as
flavor in prose, but skills are workflows, not characters — no heavy persona
overhead. Match the surrounding skills' structure and tone.

## License

By contributing you agree your work is licensed under [MIT](LICENSE). The BMAD
Method™ name and methodology remain the property of the BMAD Code Organization.
