# Knowledge Vault

Personal knowledge management repository combining the **PARA** method
(organization by actionability) with the **Zettelkasten** method (atomic,
cross-linked notes). All content is plain Markdown.

## Structure

```
knowledge-vault/
├── 0-Inbox/              # Unsorted fleeting notes awaiting triage
├── 1-Projects/           # Active projects: defined outcome + deadline
│   ├── <slug>.md         # simple project (single file)
│   └── <slug>/<slug>.md  # project with supporting files (folder form)
│       └── drafts/       # (optional) blog post drafts for that project — see Publisher
├── 2-Areas/              # Ongoing areas of responsibility, no end date
├── 3-Resources/          # Reference material, source/literature notes, topics of ongoing interest
├── 4-Archive/            # Mirrors 1/2/3 above: 1-Projects/, 2-Areas/, 3-Resources/
├── Journal/
│   ├── YYYY/MM/YYYY-MM-DD/<zettel-id>.md   # Zettelkasten notes, filed by the day they were written
│   └── templates/        # Note templates (e.g. zettel-template.md)
├── agents/               # Per-role agent context prompts (librarian, project-manager, ...)
├── tmp/                  # Inter-agent communication directory
│   ├── target-librarian/     # Pending tasks for Librarian agent
│   ├── target-project-manager/  # Pending tasks for Project Manager agent
│   ├── target-archivist/     # Pending tasks for Archivist agent
│   ├── target-performance-reviewer/  # Pending tasks for Performance Reviewer agent
│   ├── target-architect/     # Pending tasks for Architect agent
│   ├── target-software-engineer/  # Pending tasks for Software Engineer agent
│   ├── target-publisher/     # Pending tasks for Publisher agent
│   ├── target-advisor/       # Pending tasks for Advisor agent (conversational role, rarely used)
│   └── target-$agent/         # Pending tasks for other agents
├── AGENTS.md             # Index of agents/ — read PREFERENCES.md first
└── PREFERENCES.md        # Master preferences for all agents
```

### PARA

- **Projects** — short-term efforts with a clear goal and deadline.
- **Areas** — long-term responsibilities to maintain over time.
- **Resources** — reference material and topics of ongoing interest,
  including source/literature notes (summaries, quotes) taken from books,
  articles, or talks.
- **Archive** — inactive items from any of the above, moved into a mirrored
  `4-Archive/1-Projects|2-Areas|3-Resources/` structure (same slug/filename,
  new parent folder) so `project`/`area`/`resource` frontmatter references
  keep resolving — search checks the live folder first, then Archive.

### Journal (Zettelkasten)

- Every atomic note (one idea, in your own words) lives under
  `Journal/YYYY/MM/YYYY-MM-DD/<zettel-id>.md`, filed by the date it was
  written. The trailing `YYYY-MM-DD` folder repeats the parent path on
  purpose — it keeps each day self-contained for fast search/navigation.
- New notes start from `Journal/templates/zettel-template.md`.
- Fleeting captures go to `0-Inbox/` first and get triaged into the
  structure above (either a PARA folder or a dated `Journal` note) during
  review.
- A zettel note can relate to a `Project`, `Area`, and/or `Resource` — see
  the frontmatter schema below.

## Conventions

- Zettel id / filename: `YYYYMMDDHHmm` (creation timestamp), e.g.
  `Journal/2026/08/2026-08-24/202608241030.md`.
- Use relative Markdown links between notes.
- Tag notes with YAML frontmatter (`tags: []`) for topical retrieval.

### Frontmatter schema

Zettel notes (`Journal/**/*.md`):

```yaml
id: YYYYMMDDHHmm
title:
aliases: []    # alternate display names
tags: []
created: YYYY-MM-DD
links: []      # ids of related Journal notes
project: []    # slugs (filename, no path/extension) of files in 1-Projects/ this note supports
area: []       # slugs (filename, no path/extension) of files in 2-Areas/ this note supports
resource: []   # slugs (filename, no path/extension) of files in 3-Resources/ this note references
people: []     # slugs identifying peers/reports this note involves (tag only, no backing file)
```

PARA notes (`1-Projects/`, `2-Areas/`, `3-Resources/`):

```yaml
id: YYYYMMDDHHmm
title:
aliases: []    # alternate display names
tags: []
created: YYYY-MM-DD
status: active   # active | paused | done | archived
people: []     # slugs identifying peers/reports this note involves (tag only, no backing file)
```

## Agents

This vault is worked on by several specialized agents (Librarian, Project
Manager, Archivist, Performance Reviewer, Architect, Senior Software
Engineer, Publisher, Advisor), each with its own context prompt under `agents/`.
Notably, the Architect reasons from this vault's own content, while the
Senior Software Engineer is a read-only debugging/Q&A role over enterprise
GitHub repos — see `agents/architect.md` and `agents/software-engineer.md`.
The Publisher turns vault content into posts for Juan's Jekyll/
minimal-mistakes blog at cornerinthemiddle.com, drafted under
`1-Projects/<slug>/drafts/` — see `agents/publisher.md`. The Advisor
handles personal guidance, reflection, and cultural awareness conversations
— see `agents/advisor.md`. See `AGENTS.md` for the full index and
`PREFERENCES.md` for communication/working preferences shared by all of them.

## Devin

This repository includes a [Devin](https://devin.ai) environment blueprint
at `.devin/blueprint.yaml` so it can be opened as a Devin workspace with no
manual environment setup (documentation-only repo, no build/test steps).
