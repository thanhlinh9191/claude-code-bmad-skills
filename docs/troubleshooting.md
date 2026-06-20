---
layout: default
title: "BMAD Planning & Orchestrator - Troubleshooting"
description: "Solutions for common issues with the bmad-planning-orchestrator plugin: skills not appearing, marketplace install problems, project-scope trust, and plugin path configuration."
keywords: "BMAD troubleshooting, Claude Code plugin, bmad-planning-orchestrator, skills not appearing, reload-plugins, plugin marketplace"
---

# Troubleshooting

Solutions for common issues with the **bmad-planning-orchestrator** Claude Code plugin.

> **Attribution:** The BMAD Method™ (Breakthrough Method for Agile AI-Driven Development) is created and maintained by the [BMAD Code Organization](https://github.com/bmad-code-org/BMAD-METHOD). This plugin is an independent harness — not an official BMAD product, and no endorsement is implied. All methodology credit belongs to the BMAD Code Organization.

---

## Quick Fixes

Before diving into specific issues, try these in order:

1. **Run `/reload-plugins`** — reloads all installed plugins without a full restart
2. **Restart Claude Code** — full restart if `/reload-plugins` does not help
3. **Check project-scope trust** — some organizations require explicit plugin trust per project
4. **Verify `${CLAUDE_PLUGIN_ROOT}`** — set this env variable when using a non-standard plugin directory

---

## Plugin Installation Issues

### Plugin Not Appearing in the Marketplace

**Symptom:** `/plugin marketplace add aj-geddes/claude-code-bmad-skills` returns an error or the plugin does not show up.

**Causes & Fixes:**

1. **Network or auth issue**

   Confirm you are signed in and have network access, then retry:
   ```
   /plugin marketplace add aj-geddes/claude-code-bmad-skills
   ```

2. **Marketplace cache stale**

   Force a refresh:
   ```
   /plugin marketplace refresh
   /plugin marketplace add aj-geddes/claude-code-bmad-skills
   ```

3. **Organization policy blocks third-party plugins**

   Check with your Claude Code administrator. Your org settings may need to allowlist `aj-geddes/claude-code-bmad-skills` before individual users can install it.

---

### `/plugin install` Fails

**Symptom:** The install command errors out or completes but skills never appear.

**Full install sequence (run in order):**

```
/plugin marketplace add aj-geddes/claude-code-bmad-skills
/plugin install bmad-planning-orchestrator@bmad-method-harness
/reload-plugins
```

**If the install step errors:**

- Confirm the marketplace add succeeded first.
- Verify you are using the exact tag `bmad-method-harness`. Other tags are not supported install targets.
- If your session is stale, restart Claude Code and retry the full sequence from the top.

---

### Skills Still Not Appearing After Install

**Symptom:** Install reported success but `/bmad-planning-orchestrator:bmad-help` (or any other skill) is not recognized.

**Causes & Fixes:**

1. **Did not run `/reload-plugins`**

   Plugins are registered at load time. Always run:
   ```
   /reload-plugins
   ```
   after any install or update.

2. **Full restart required**

   If `/reload-plugins` does not resolve it, close and reopen Claude Code entirely.

3. **Project-scope trust not granted**

   Claude Code may require you to trust the plugin for the current project before skills are active. When prompted, confirm trust. If you are not prompted, check whether your project has a `.claude/settings.json` that blocks plugin permissions.

4. **Local dev path not set**

   If you are developing locally (not using the marketplace), you must launch Claude Code with the plugin directory flag:
   ```bash
   claude --plugin-dir ./bmad-planning-orchestrator
   ```
   Skills will not appear if you run `claude` without this flag in a local dev setup.

---

## Skill Invocation Issues

### Skill Not Auto-Invoking

**Symptom:** You describe a planning task and the plugin skill does not auto-invoke.

**How auto-invocation works:** Claude matches your natural-language request against each skill's `description` field. The 20 skills in this plugin cover planning and orchestration only. Skills will not auto-invoke for code generation, test execution, linting, coverage, or diff review — those are out of scope by design.

**Fixes:**

1. **Use explicit skill syntax:**
   ```
   /bmad-planning-orchestrator:bmad-help
   ```
   This bypasses auto-invocation and runs the skill directly.

2. **Start with `bmad-help`:**

   `bmad-help` reads your current artifact state and routes you to the correct next skill. When in doubt, run it first.

3. **Rephrase toward planning intent:**

   Instead of "build a login screen", try "plan the stories for a login screen" or "what planning artifacts do I need for a login feature".

---

### "Unknown skill" Error

**Symptom:** `/bmad-planning-orchestrator:<skill-name>` returns "unknown skill".

**Causes & Fixes:**

1. **Plugin not loaded** — run `/reload-plugins` and retry.

2. **Typo in skill name** — the 20 supported skills are:

   | Skill | Phase |
   |-------|-------|
   | `bmad-help` | Orchestration spine |
   | `bmad-init` | Orchestration spine |
   | `bmad-brainstorm` | Analysis |
   | `bmad-research` | Analysis |
   | `bmad-product-brief` | Analysis |
   | `bmad-prfaq` | Analysis |
   | `bmad-spec` | Analysis |
   | `bmad-prd` | Planning |
   | `bmad-tech-spec` | Planning |
   | `bmad-ux` | Solutioning |
   | `bmad-architecture` | Solutioning |
   | `bmad-epics-and-stories` | Solutioning |
   | `bmad-readiness-check` | Solutioning |
   | `bmad-sprint-planning` | Orchestration & Handoff |
   | `bmad-parallel-plan` | Orchestration & Handoff |
   | `bmad-handoff` | Orchestration & Handoff |
   | `bmad-correct-course` | Cross-phase |
   | `bmad-investigate` | Cross-phase |
   | `bmad-document-project` | Cross-phase |
   | `bmad-builder` | Meta |

---

## Project-Scope Trust

**Symptom:** Skills invoke in one project but not another, or you see a trust/permission prompt.

Claude Code enforces plugin trust at the project level. When you open a new project directory, you may need to grant trust to the plugin before skills are active.

**Fix:**

When Claude Code prompts you to trust the plugin for the current project, confirm. If the prompt does not appear and skills are not active:

1. Check `.claude/settings.json` in your project root for a `plugins` or `permissions` block that may be blocking the plugin.
2. If your organization manages settings centrally, contact your Claude Code administrator to add `bmad-planning-orchestrator` to the allowlist.

---

## Local Development Setup

**Symptom:** You cloned the repo to test changes but skills are not loading.

The marketplace install path is not used during local development. Instead, pass the plugin directory at launch:

```bash
claude --plugin-dir ./bmad-planning-orchestrator
```

Run this from the repository root (the directory that *contains* `bmad-planning-orchestrator/`).

If you have `${CLAUDE_PLUGIN_ROOT}` set in your environment, Claude Code will use that directory as the base for `--plugin-dir` resolution. Confirm the variable points to the right parent:

```bash
echo $CLAUDE_PLUGIN_ROOT
```

If it is set incorrectly (or to an old path), unset or update it before launching:

```bash
unset CLAUDE_PLUGIN_ROOT
claude --plugin-dir ./bmad-planning-orchestrator
```

---

## Workflow & Artifact Issues

### "No workspace found" or Missing Artifacts

**Symptom:** A skill cannot find `project-context.md`, `prd.md`, `architecture.md`, or other expected artifacts.

**Fix:** Run `bmad-init` first. It creates the workspace, `decision-log.md`, and `project-context.md` that every downstream skill depends on:

```
/bmad-planning-orchestrator:bmad-init
```

Then use `bmad-help` to check which phase you are in and which skill to run next.

---

### Wrong Track Selected

**Symptom:** The plugin is running more (or fewer) planning phases than your project needs.

**Tracks and their scope:**

| Track | Typical story count | Planning artifacts |
|-------|---------------------|--------------------|
| **Quick Flow** | 1–15 stories | Tech spec only |
| **BMad Method** | 10–50+ stories | PRD + Architecture (+ optional UX) |
| **Enterprise** | 30+ stories | PRD + Architecture + Security + DevOps |

If you selected the wrong track during `bmad-init`, run `bmad-correct-course` to adjust scope without re-doing work:

```
/bmad-planning-orchestrator:bmad-correct-course
```

---

### Readiness Check Fails

**Symptom:** `bmad-readiness-check` returns CONCERNS or FAIL.

This is expected behavior. The readiness check is a gate before handoff — a FAIL means your planning artifacts have gaps that would cause problems during implementation. Read the check output, address the flagged items in the relevant upstream skill (`bmad-architecture`, `bmad-prd`, `bmad-epics-and-stories`), then re-run the check.

Do not skip this gate. A FAIL here costs minutes to fix in planning; the same gap discovered mid-build costs hours.

---

### Handoff Manifest Not Generated

**Symptom:** `bmad-handoff` does not produce `handoff-manifest.json`.

**Causes & Fixes:**

1. **Stories not marked `ready-for-dev`** — `bmad-handoff` only includes stories with `status: ready-for-dev`. Run `bmad-epics-and-stories` and `bmad-readiness-check` first.

2. **`bmad-parallel-plan` not run** — the manifest includes wave/parallel-set data produced by `bmad-parallel-plan`. Run it before `bmad-handoff`.

3. **Output directory missing** — confirm your configured output folder exists. By default it is `bmad-output/` in your project root.

---

### Out-of-Scope Requests

**Symptom:** You ask the plugin to write code, run tests, lint files, check coverage, or review a diff — and nothing useful happens.

This plugin plans and orchestrates only. It never writes implementation code, executes tests, runs linters, measures coverage, or reviews implemented diffs. The last artifact it produces is a `ready-for-dev` story file and `handoff-manifest.json`. Pass those to your dev tool (Claude Code with a dev plugin, an autonomous runner, etc.) for implementation.

---

## Common Error Messages

### "Plugin not installed"

Run the full install sequence:

```
/plugin marketplace add aj-geddes/claude-code-bmad-skills
/plugin install bmad-planning-orchestrator@bmad-method-harness
/reload-plugins
```

---

### "Plugin trust required"

Grant project-scope trust when prompted. If you dismissed the prompt, restart Claude Code in the project directory to trigger it again, or check `.claude/settings.json` for a plugin trust block.

---

### "Skill file not found" or "SKILL.md missing"

If you are using a local dev install, confirm you launched with `--plugin-dir ./bmad-planning-orchestrator` and that the `skills/` directory contains the expected skill folders. Run:

```bash
ls ./bmad-planning-orchestrator/skills/
```

You should see all 20 skill directories. If any are missing, re-clone the repository.

---

## Updating the Plugin

To update to the latest version:

```
/plugin update bmad-planning-orchestrator
/reload-plugins
```

If the update command is not available in your Claude Code version, uninstall and reinstall:

```
/plugin uninstall bmad-planning-orchestrator
/plugin install bmad-planning-orchestrator@bmad-method-harness
/reload-plugins
```

---

## Getting Help

### Documentation

- [Getting Started](./getting-started) — install and first steps
- [Skills Reference](./skills/) — all 20 skill descriptions
- [Subagent Patterns](./subagent-patterns) — parallel planning architecture

### Report Issues

If you have tried the fixes above and the problem persists, open an issue:

**GitHub Issues:** [github.com/aj-geddes/claude-code-bmad-skills/issues](https://github.com/aj-geddes/claude-code-bmad-skills/issues)

Include:
- Claude Code version
- Plugin version or git commit
- Operating system
- Full error message
- Steps to reproduce
- Output of `/reload-plugins` if relevant

---

## Quick Reference

| Issue | Fix |
|-------|-----|
| Skills not appearing after install | `/reload-plugins`, then restart Claude Code |
| Marketplace add fails | Check network / org policy; try `/plugin marketplace refresh` first |
| Plugin not trusted in new project | Confirm trust prompt or check `.claude/settings.json` |
| Local dev skills not loading | Launch with `claude --plugin-dir ./bmad-planning-orchestrator` |
| `${CLAUDE_PLUGIN_ROOT}` wrong | `unset CLAUDE_PLUGIN_ROOT` then relaunch |
| Skill not auto-invoking | Use `/bmad-planning-orchestrator:<skill>` directly or run `bmad-help` |
| No workspace / missing artifacts | Run `bmad-init` first |
| Wrong track chosen | Run `bmad-correct-course` |
| Readiness check fails | Fix flagged items upstream, then re-run the check |
| Handoff manifest missing | Run `bmad-parallel-plan` before `bmad-handoff` |
| Plugin asked to write code | Out of scope — pass story files to your dev tool |
