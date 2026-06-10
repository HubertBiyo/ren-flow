# ren-flow — a Vibe Coding workflow

> [中文](./README.md) | English

**ren = 人 (rén, "human")** — the core of this whole workflow is *human-in-the-loop*: humans own intent and acceptance, the AI is the fast executor.

A team-oriented set of Vibe Coding skills for AI-assisted development, shipped as a Claude Code plugin. Three design choices: **lean** (16 skills, one shared set), **role-agnostic** (frontend / backend / client all share the same skills — not split by role), and **speed-biased** (small changes take the fast path; only big ones go through the full spec process).

## What it solves

The normal mode of Vibe Coding is "developer dictates intent → AI executes fast." Great — but left unmanaged it keeps manufacturing the same class of trouble:

- Requirements live only in your head; once the change is done they're forgotten, and three months later nobody can say why it was built that way.
- The AI gets a request and writes code straight away — naming drifts from the existing repo, and scope creeps mid-change.
- A bug gets patched at the surface; the root cause is never touched, so it blows up again next time.
- Hard-won lessons aren't captured, so both the team and the AI keep stepping on the same rakes.

ren-flow doesn't orchestrate agents — it **orchestrates the software lifecycle itself**: intent → spec → code → acceptance → knowledge. Humans set intent and acceptance; the AI is the efficient executor.

## Three core principles

1. **Human-in-the-loop** — the developer owns intent and acceptance; the AI never makes the call for you. When unsure, it stops and asks.
2. **Structure serves speed** — anything you can finish in 30 minutes takes the fast path with no spec; only work that spans many files / needs a record / needs multi-person alignment goes through the full process.
3. **Compounding knowledge** — every pitfall and good practice is captured into `.ren-flow/notes/`, so the AI understands the project better the more you use it.

## The system: 6 artifact types + 3 flows

Everything lives under `.ren-flow/` at the repo root:

```
.ren-flow/
├── attention.md          read on every start: project hard constraints / build commands / off-limits dirs
├── arch/                 current architecture (ARCHITECTURE.md + optional schemas/ indexes/ openapi/)
├── specs/                spec aggregate root (design + acceptance for new capabilities)
├── fixes/                bug-fix records
├── refactors/            refactor records (behavior unchanged, structure changed)
├── roadmap/              breakdown and scheduling of large requirements
├── requirements/         requirement docs (PRD / US) + traceability matrix (RTM) (optional)
├── notes/                captured knowledge (pitfalls / recipes / decisions / research)
├── deploy/               release / ops material (standing release checklist / K8s / scripts, optional)
├── inbox/                idea inbox (one folder per month, one file per day)
├── journal/              daily work log (one folder per month, one file per day)
├── templates/            reusable cross-domain scaffolds (new app / CI / K8s, optional)
└── _archive/             archived finished artifacts (`_archive/{type}/{YYYYMM}/{slug}/`)
```

Retrieval: artifact frontmatter carries `tags` / `summary` / `kind` fields — `Grep` those to locate historical specs / fixes / decisions, no separate index needed.

**Two shapes**: a single repo uses the layout above directly; when one folder holds multiple projects (a multi-domain workspace), wrap `specs/fixes/...` in a domain layer — `.ren-flow/domains/{domain}/specs/...`, one set per domain (each with its own `_archive/`). Only `journal/`, `inbox/` (and the optional `templates/`) are domain-free and stay at the workspace root. `ren-init` detects the shape automatically and records it in the `mode` field of the root `attention.md`.

**Three flows:**

- **New capability**: `ren-spec` (spec) → `ren-build` (implement) → `ren-verify` (accept)
- **Bug fix**: `ren-fix` (record → locate → fix, phased within a single skill)
- **Large requirement**: `ren-roadmap` first breaks it into modules and pins interfaces, then each block goes through `ren-spec`

The main flow wraps up with `ren-ship` (commit / commit message / PR). Cross-cutting skills are available any time: `ren-explore` (read code), `ren-review` (review / receive review), `ren-refactor` (refactor), `ren-note` (capture), `ren-arch` (architecture docs), `ren-log` (daily log), `ren-inbox` (idea inbox).

## The 16 skills (by stage)

Skill names carry no sequence numbers — the flow is a graph (three lines + cross-cutting), not a single line. Order is chosen at runtime by the `ren` root router based on context; the grouping below shows the typical sequence.

**Entry** — when you don't know which to use, start here

| Skill | Role |
|---|---|
| `ren` | root router: directs open-ended asks to the right sub-skill (also explains the system) |
| `ren-bootstrap` | cold-start a brand-new repo / service: pull scaffold templates + build a compilable skeleton (then hand off to `ren-init`) |
| `ren-init` | onboard a repo / workspace into ren-flow, build the `.ren-flow/` skeleton |

**Main flow: new capability** — straight down the line

```
ren-spec  →  ren-build  →  ren-verify  →  ren-ship
  spec        implement     accept         wrap up / commit
```

**Bug fix** — `ren-fix`, three phases in one skill: record the symptom → trace the root cause → targeted fix and verify

**Large requirement** — `ren-roadmap`, break into modules and pin interface contracts; each resulting sub-requirement runs through the "main flow" again

**Cross-cutting** — insertable at any stage

| Skill | Role |
|---|---|
| `ren-explore` | read code / investigate, no changes |
| `ren-refactor` | refactor (behavior unchanged, structure changed): scan → select → change step by step |
| `ren-review` | code review / proactive audit / receiving review comments |
| `ren-note` | capture knowledge (pitfalls / recipes / decisions / research) |
| `ren-arch` | build and refresh the current-architecture doc |
| `ren-log` | daily work log, rolling up the day's feature points |
| `ren-inbox` | idea inbox: capture interrupting requests / ideas on the fly, triage and route them later |

## Install

This repo is a Claude Code plugin + marketplace. See [`INSTALL.md`](./INSTALL.md) — two commands:

```
/plugin marketplace add https://github.com/HubertBiyo/ren-flow.git
/plugin install ren-flow@ren-flow
```

## How to use

1. In a new repo, run `ren-init` first to build the skeleton.
2. After that just talk normally; when unsure which skill applies, trigger the `ren` root router and it will point the way.
3. Role doesn't affect skill choice — frontend, backend, and client all use the same set; stack-specific differences live in the project's own `.ren-flow/attention.md`.

> Plugin skills are namespaced: the actual invocation names are `/ren-flow:ren-spec`, `/ren-flow:ren-fix`, etc. (the `ren-flow` prefix is the plugin name). In most cases Claude invokes them automatically from the skill description — you rarely type them by hand.

## Why role-agnostic

There is no `ren-build-frontend` / `ren-build-backend`. The reasoning: what a skill needs to compensate for is **process** and **project-specific knowledge**, not language syntax — the model already knows the latter. Each stack's hard constraints (naming, build commands, layering rules, common pitfalls) go into the project's `.ren-flow/attention.md`; `ren-build` reads it on start and treats frontend, backend, and client alike.

## Maintenance

See `AGENTS.md` for skill-maintenance conventions. Two structural rules:

- **Progressive disclosure** — each `SKILL.md` is a thin, always-loaded manifest (trigger logic + flow skeleton); mode-specific templates / examples / long checklists are split into that skill's `references/`, `Read` on demand by path, so the common path doesn't pay for heavy-path detail.
- **Routing regression eval** — `evals/` holds "user's own words → expected route" cases plus a replay procedure. After changing any skill's `description:` or the `ren` routing table, replay it to confirm routing hasn't regressed (especially around easily-colliding triggers like log / inbox / note). See `evals/README.md`.

## License

[MIT](./LICENSE)
