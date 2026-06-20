---
layout: default
title: "Examples"
description: "End-to-end worked example: a small product taken from brief to PRD to architecture to epics/stories with Owned File/Module Scope to a conflict-free parallel wave plan and handoff-manifest.json."
keywords: "BMAD examples, parallelization plan, handoff manifest, epics and stories, wave plan, Claude Code plugin, BMAD Method"
---

# Worked Example: Brief to Handoff

This page walks a single small product — a task-management REST API — through every planning
phase of the **BMAD Planning & Orchestrator** plugin, from a two-sentence idea to a
`handoff-manifest.json` that an external dev tool can immediately consume.

> **Attribution.** The BMAD Method is created and maintained by the
> [BMAD Code Organization](https://github.com/bmad-code-org/BMAD-METHOD).
> This plugin is an independent harness; no endorsement is implied.
> All methodology credit belongs to the BMAD Code Organization.

---

## Plugin install (quick reference)

```text
/plugin marketplace add aj-geddes/claude-code-bmad-skills
/plugin install bmad-planning-orchestrator@bmad-method-harness
/reload-plugins
```

Local development: `claude --plugin-dir ./bmad-planning-orchestrator`

Skills are namespaced `/bmad-planning-orchestrator:<skill>` and most are auto-invoked
based on context. The plugin **plans and orchestrates only**. It never writes code,
runs tests, lints, or reviews diffs. Its last artifact is a `ready-for-dev` story file
plus a `handoff-manifest.json` for your dev tool.

---

## The product: TaskFlow API

> A lightweight task-management API — users, projects, tasks, comments — built for a small
> team shipping a mobile client. Roughly 12–18 stories. One dev team.

---

## Phase 1 — Analysis: product brief

The user starts from nothing and invokes `bmad-init`. The plugin suggests **BMad Method**
track (PRD + Architecture) for a 12–18 story scope, the user confirms, and the workspace is
scaffolded at `bmad-output/`.

```
/bmad-planning-orchestrator:bmad-init

> Project name: TaskFlow API
> Estimated story count: ~15
> Track suggestion: BMad Method (10-50+ stories, PRD + Architecture)
> Confirm? yes

Scaffolded:
  bmad-output/config.yaml
  bmad-output/decision-log.md
  bmad-output/project-context.md
  bmad-output/stories/   (empty)
```

Then `bmad-product-brief` captures the product's core problem and success metrics:

```
/bmad-planning-orchestrator:bmad-product-brief

Problem: teams lose track of tasks across Slack, email, and spreadsheets.
Users: developers and their team leads.
Success metrics:
  - Task creation round-trip < 200 ms at P95
  - Zero data loss on concurrent edits
  - Mobile client can build against a stable API contract from day 1

Saved: bmad-output/product-brief.md
```

---

## Phase 2 — Planning: PRD

`bmad-prd` reads the product brief and produces `prd.md` with functional requirements
(FR-###), non-functional requirements (NFR-###), and an epic outline.

```
/bmad-planning-orchestrator:bmad-prd

Loading: bmad-output/product-brief.md

Functional Requirements
  FR-01  User registration, login, JWT auth (bcrypt + RS256)
  FR-02  Project CRUD (name, description, archived flag, owner)
  FR-03  Task CRUD (title, body, status, assignee, due-date, priority)
  FR-04  Task status transitions: todo -> in-progress -> done -> archived
  FR-05  Comment threads on tasks (create, list, delete own)
  FR-06  Role-based access: owner / member / viewer per project

Non-Functional Requirements
  NFR-01  API response P95 < 200 ms under 500 RPS sustained
  NFR-02  JWT expiry 1 hour; refresh token 7 days
  NFR-03  All endpoints require authentication except /auth/*
  NFR-04  Postgres 15; no in-process state (stateless API tier)

Epic outline
  Epic 1  Foundation (project scaffold, CI, DB migrations)
  Epic 2  Auth (register, login, JWT, middleware)
  Epic 3  Projects (CRUD, roles, membership)
  Epic 4  Tasks (CRUD, status machine, assignments)
  Epic 5  Comments (create, list, delete)

Saved: bmad-output/prd.md
       bmad-output/decision-log.md  (appended)
```

---

## Phase 3 — Solutioning: architecture

`bmad-architecture` reads the PRD and produces `architecture.md` plus ADRs. Its job here is
**semantic-conflict prevention**: every module boundary it declares becomes the wall between
stories that will run in parallel.

```
/bmad-planning-orchestrator:bmad-architecture

Loading: bmad-output/prd.md

Component map
  src/api/routes/         HTTP route handlers (thin)
  src/services/           Business logic — one service per domain
  src/db/migrations/      Postgres migration files (sequential by prefix)
  src/db/models/          TypeORM entity definitions
  src/middleware/         require-auth, error-handler, request-logger
  src/types/              Shared TypeScript interfaces (auth, task, project)

Shared / cross-cutting modules (high-conflict — serialized by default)
  src/types/              Any story touching shared types must coordinate
  src/db/migrations/      Sequential; no two stories share a migration slot
  src/middleware/require-auth.ts  Touched by auth only; downstream stories depend on it

ADR-001  TypeORM over raw SQL — existing team familiarity, migration tooling
ADR-002  RS256 JWT — asymmetric keys; public key shared across future services
ADR-003  Stateless API tier — Redis session state deferred to v2

Semantic-conflict note written to architecture.md §Shared Modules:
  Stories touching src/types/ or src/middleware/ may not co-run unless explicitly
  declared epic-parallel with non-overlapping type definitions.

Saved: bmad-output/architecture.md
       bmad-output/adrs/ADR-001.md … ADR-003.md
       bmad-output/decision-log.md  (appended)
```

---

## Phase 3 — Solutioning: epics and stories with Owned File/Module Scope

`bmad-epics-and-stories` shards the PRD and architecture into an epic map and per-story
context objects. Each story is sized to roughly one dev-day (2–8 hours). No story points —
delivery is tracked by count.

The critical output for parallel safety is the **Owned File/Module Scope**: the explicit,
exhaustive list of paths a story is allowed to touch. Two stories whose scope lists
intersect may not share a wave.

```
/bmad-planning-orchestrator:bmad-epics-and-stories

Loading: bmad-output/prd.md, bmad-output/architecture.md

Generated epics.md and 14 story files:

EPIC 1 — Foundation
  1.1.project-scaffold   src/, package.json, tsconfig.json,
                         .github/workflows/ci.yml
  1.2.base-migration     src/db/migrations/001_create_schema.sql,
                         src/db/data-source.ts

EPIC 2 — Auth
  2.1.user-model         src/db/migrations/002_create_users.sql,
                         src/db/models/user.entity.ts,
                         src/types/auth.types.ts
  2.2.auth-service       src/services/auth-service.ts,
                         src/services/__tests__/auth-service.test.ts
  2.3.auth-routes        src/api/routes/auth.ts,
                         src/api/routes/__tests__/auth.routes.test.ts
  2.4.auth-middleware    src/middleware/require-auth.ts,
                         src/middleware/__tests__/require-auth.test.ts

EPIC 3 — Projects
  3.1.project-model      src/db/migrations/003_create_projects.sql,
                         src/db/models/project.entity.ts
  3.2.project-service    src/services/project-service.ts,
                         src/services/__tests__/project-service.test.ts
  3.3.project-routes     src/api/routes/projects.ts,
                         src/api/routes/__tests__/projects.routes.test.ts

EPIC 4 — Tasks
  4.1.task-model         src/db/migrations/004_create_tasks.sql,
                         src/db/models/task.entity.ts
  4.2.task-service       src/services/task-service.ts,
                         src/services/__tests__/task-service.test.ts
  4.3.task-routes        src/api/routes/tasks.ts,
                         src/api/routes/__tests__/tasks.routes.test.ts

EPIC 5 — Comments
  5.1.comment-model      src/db/migrations/005_create_comments.sql,
                         src/db/models/comment.entity.ts
  5.2.comment-service    src/services/comment-service.ts,
                         src/services/__tests__/comment-service.test.ts,
                         src/api/routes/comments.ts

Scope-conflict check: CLEAN (no two stories share a path)
All 14 stories set to status: ready-for-dev

Saved: bmad-output/epics.md
       bmad-output/stories/1.1.project-scaffold.story.md … 5.2.comment-service.story.md
```

A sample story file looks like this (abbreviated):

```markdown
# Story 2.4 — Auth Middleware

## Status
ready-for-dev

## Story
As a protected-route handler, I want a require-auth middleware that validates
a JWT and attaches the decoded principal, so that route handlers never deal
with token parsing.

## Acceptance Criteria
1. Given a valid RS256 JWT in the Authorization header, when middleware runs,
   then `req.user` is set and `next()` is called.
2. Given an expired token, when middleware runs, then a 401 with body
   `{"error": "Token expired"}` is returned and `next()` is not called.
3. Given no Authorization header, when middleware runs, then a 401 is returned.

## Owned File/Module Scope
- src/middleware/require-auth.ts
- src/middleware/__tests__/require-auth.test.ts

## Dependency Map
depends_on: [2.3.auth-routes]
blocks: [3.3.project-routes, 4.3.task-routes, 5.2.comment-service]

## Dev Notes
JWT secret is an RSA public key loaded from env `JWT_PUBLIC_KEY`.
[Source: architecture.md#ADR-002]
Use jsonwebtoken@^9 `verify()` with `{ algorithms: ["RS256"] }`.
[Source: architecture.md#auth-service]

## Testing
Unit: mock `jsonwebtoken.verify` to cover valid / expired / malformed paths.
Integration: send real tokens from auth-service fixture.
No e2e in this story — covered by auth-routes story.

## Dev Agent Record
(empty — populated by external dev tool)
```

---

## Phase 3 — Orchestration: parallel plan

`bmad-parallel-plan` reads the dependency maps and owned scopes, builds a DAG, and
topologically sorts it into conflict-free waves (capped at `maxParallel: 3`).

The rules are:
- A story enters a wave only after every `depends_on` story is in an earlier wave.
- No two stories in a wave may have overlapping Owned File/Module Scope.
- No two stories in a wave may both touch a shared/cross-cutting module (semantic safety).

```
/bmad-planning-orchestrator:bmad-parallel-plan

Loading: bmad-output/sprint-status.yaml, bmad-output/stories/, bmad-output/architecture.md
Shared modules (semantic exclusion): src/types/, src/db/migrations/, src/middleware/

Building dependency DAG ...
Topological sort with maxParallel=3 ...

Wave 1  (no dependencies — can start immediately)
  story/1.1-project-scaffold    src/, package.json, tsconfig.json, .github/
  story/1.2-base-migration      src/db/migrations/001_create_schema.sql, src/db/data-source.ts
  [maxParallel reached — next ready story deferred to wave 2]

Wave 2  (after wave 1 merges to main)
  story/2.1-user-model          src/db/migrations/002_create_users.sql,
                                src/db/models/user.entity.ts, src/types/auth.types.ts
  — 3.1.project-model depends on 2.1 (user FK) → deferred to wave 3
  — 4.1.task-model depends on 3.1 → deferred to wave 4

Wave 3
  story/2.2-auth-service        src/services/auth-service.ts, ...
  story/3.1-project-model       src/db/migrations/003_create_projects.sql,
                                src/db/models/project.entity.ts
  story/4.1-task-model          src/db/migrations/004_create_tasks.sql,
                                src/db/models/task.entity.ts
  Note: 3.1 and 4.1 touch different migration slots — no scope conflict.

Wave 4
  story/2.3-auth-routes         src/api/routes/auth.ts, ...
  story/3.2-project-service     src/services/project-service.ts, ...
  story/5.1-comment-model       src/db/migrations/005_create_comments.sql,
                                src/db/models/comment.entity.ts

Wave 5
  story/2.4-auth-middleware     src/middleware/require-auth.ts, ...
  story/3.3-project-routes      src/api/routes/projects.ts, ...
  story/4.2-task-service        src/services/task-service.ts, ...

Wave 6
  story/4.3-task-routes         src/api/routes/tasks.ts, ...
  story/5.2-comment-service     src/services/comment-service.ts, ...

Saved: bmad-output/parallelization-plan.md
       bmad-output/dependency-graph.json
       bmad-output/waves.json
       bmad-output/decision-log.md  (appended: 6 waves, maxParallel=3, 0 deferred)
```

The full plan is saved to `bmad-output/parallelization-plan.md`. A concrete example of
what that file looks like is in the companion artifact:
[`bmad-planning-orchestrator/examples/parallelization-plan.example.md`](https://github.com/aj-geddes/claude-code-bmad-skills/blob/main/bmad-planning-orchestrator/examples/parallelization-plan.example.md).

---

## Phase 3 — Orchestration: handoff manifest

`bmad-handoff` scans every `ready-for-dev` story and emits `handoff-manifest.json` —
the stable, versioned interface your external dev tool reads.

```
/bmad-planning-orchestrator:bmad-handoff

Discovered 14 stories at status: ready-for-dev
Computing wave order from Dependency Maps ...

Handoff manifest written → bmad-output/handoff-manifest.json
  schemaVersion : 1.0
  stories       : 14 ready-for-dev
  waves         : 6  (wave 1 has 2 stories, can start immediately)
  output path   : bmad-output/handoff-manifest.json
```

A condensed excerpt of `handoff-manifest.json`:

```json
{
  "schemaVersion": "1.0",
  "generatedAt": "2026-06-19T14:30:00Z",
  "projectName": "taskflow-api",
  "outputFolder": "bmad-output",
  "stories": [
    {
      "id": "1.1.project-scaffold",
      "storyFilePath": "bmad-output/stories/1.1.project-scaffold.story.md",
      "status": "ready-for-dev",
      "epic": "1",
      "storyNumber": "1",
      "title": "Project Scaffolding and CI Pipeline",
      "ownedScope": [
        "package.json",
        "tsconfig.json",
        ".github/workflows/ci.yml",
        "src/"
      ],
      "wave": 1,
      "parallelSet": null,
      "dependencies": [],
      "acceptanceCriteriaSummary": [
        "Given a clean checkout, when npm install && npm run build runs, then it exits 0",
        "Given a push to any branch, when the CI workflow triggers, then lint and type-check pass",
        "Given a new developer, when they follow the README quickstart, then local dev server starts"
      ],
      "lockedSectionsNote": "Sections Acceptance Criteria, Dev Notes, and Testing are LOCKED. External dev tools must not edit them. Populate only the Dev Agent Record section.",
      "devAgentRecord": null
    },
    {
      "id": "2.4.auth-middleware",
      "storyFilePath": "bmad-output/stories/2.4.auth-middleware.story.md",
      "status": "ready-for-dev",
      "epic": "2",
      "storyNumber": "4",
      "title": "Auth Middleware — require-auth",
      "ownedScope": [
        "src/middleware/require-auth.ts",
        "src/middleware/__tests__/require-auth.test.ts"
      ],
      "wave": 5,
      "parallelSet": "wave-5-parallel",
      "dependencies": ["2.3.auth-routes"],
      "acceptanceCriteriaSummary": [
        "Given a valid RS256 JWT, when middleware runs, then req.user is set and next() is called",
        "Given an expired token, when middleware runs, then 401 with 'Token expired' is returned",
        "Given no Authorization header, when middleware runs, then 401 is returned"
      ],
      "lockedSectionsNote": "Sections Acceptance Criteria, Dev Notes, and Testing are LOCKED. External dev tools must not edit them. Populate only the Dev Agent Record section.",
      "devAgentRecord": null
    }
  ]
}
```

The `lockedSectionsNote` field is the contract between planning and implementation:
Acceptance Criteria, Dev Notes, and Testing were authored by the planning plugin and are
the source of truth. The external dev tool populates only `devAgentRecord`.

---

## What planning produced: the complete artifact set

```
bmad-output/
├── config.yaml                          # track: bmad-method, project: taskflow-api
├── decision-log.md                      # threaded record of every key decision
├── project-context.md                   # project "constitution" loaded by every skill
├── product-brief.md                     # Phase 1 — Analysis
├── prd.md                               # Phase 2 — Planning (FR/NFR/epics)
├── architecture.md                      # Phase 3 — Solutioning
├── adrs/
│   ├── ADR-001.md                       # TypeORM over raw SQL
│   ├── ADR-002.md                       # RS256 JWT
│   └── ADR-003.md                       # Stateless API tier
├── epics.md                             # Ordered epic map
├── stories/
│   ├── 1.1.project-scaffold.story.md    # ready-for-dev
│   ├── 1.2.base-migration.story.md
│   ├── 2.1.user-model.story.md
│   ├── 2.2.auth-service.story.md
│   ├── 2.3.auth-routes.story.md
│   ├── 2.4.auth-middleware.story.md
│   ├── 3.1.project-model.story.md
│   ├── 3.2.project-service.story.md
│   ├── 3.3.project-routes.story.md
│   ├── 4.1.task-model.story.md
│   ├── 4.2.task-service.story.md
│   ├── 4.3.task-routes.story.md
│   ├── 5.1.comment-model.story.md
│   └── 5.2.comment-service.story.md
├── sprint-status.yaml                   # sequencing roadmap (no points)
├── parallelization-plan.md              # wave plan with branch names + merge order
├── dependency-graph.json                # machine-readable DAG
├── waves.json                           # machine-readable wave assignments
└── handoff-manifest.json                # the dev-tool interface
```

Everything past `handoff-manifest.json` is owned by your external dev tooling.
The planning plugin does not write code, run tests, or review implemented diffs.

---

## Key design decisions illustrated by this example

**Why architecture prevents semantic conflicts.**
Stories 3.1 and 4.1 both run in wave 3. Their owned scopes are completely disjoint
(different migration files, different entity files). But without an architecture
document enumerating `src/types/` as a shared cross-cutting module, a naive wave
planner would not know that a story introducing `TaskStatus` might conflict with one
introducing `ProjectStatus` in the same file. Architecture is what makes parallelism
safe beyond file diffing.

**Why Owned File/Module Scope is explicit and exhaustive.**
A story with no declared scope cannot enter a wave — the planner has no way to prove
it is conflict-free. `bmad-epics-and-stories` runs `scope-conflict-check.sh` before
marking stories `ready-for-dev`, ensuring every path is declared and disjoint.

**Why delivery is count-based, not velocity-based.**
The sprint status tracks stories remaining vs. completed. No Fibonacci points, no
velocity, no burndown. One story = roughly one dev-day. The wave plan tells you how
many dev-days can run simultaneously, which is the wall-clock estimate.

**Why the handoff manifest is tool-agnostic.**
`handoff-manifest.json` carries everything a downstream runner needs (file scope,
wave, dependencies, AC summary, locked-sections contract) without coupling to any
specific orchestrator or worktree tool.

---

## Tracks: right-sizing planning effort

The plugin uses three tracks — **Quick Flow**, **BMad Method**, and **Enterprise** —
rather than numbered levels. This example used BMad Method (PRD + Architecture). A
smaller feature with fewer than 15 stories would use Quick Flow (tech-spec only, no PRD
required). A project with compliance requirements or 30+ stories would use Enterprise
(adds security and DevOps planning passes).

| Track | Story count | Planning it runs |
|-------|-------------|-----------------|
| Quick Flow | 1–15 stories | tech-spec only |
| BMad Method | 10–50+ stories | PRD + Architecture (+ optional UX) |
| Enterprise | 30+ stories | PRD + Architecture + Security + DevOps planning |

---

## Next steps

- [Skill catalog](../skills/) — full reference for all 20 skills
- [Configuration](../configuration/) — output folder, default track, maxParallel
- [Troubleshooting](../troubleshooting/) — common issues and fixes
- Companion artifact: [`bmad-planning-orchestrator/examples/parallelization-plan.example.md`](https://github.com/aj-geddes/claude-code-bmad-skills/blob/main/bmad-planning-orchestrator/examples/parallelization-plan.example.md) — the full wave plan from this example

---

> **Attribution.** The BMAD Method™ (Breakthrough Method for Agile AI-Driven Development)
> is a trademark of the [BMAD Code Organization](https://github.com/bmad-code-org/BMAD-METHOD).
> This plugin is an independent, community-built Claude Code harness — not an official
> BMAD product, and no endorsement is implied. All methodology credit belongs to the
> BMAD Code Organization.
> Method: <https://github.com/bmad-code-org/BMAD-METHOD> | Docs: <https://docs.bmad-method.org/> | Site: <https://bmadcodes.com/bmad-method/>
