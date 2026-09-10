# Agents — Index

Read `PREFERENCES.md` first — it applies to every agent below.

This vault is worked on by multiple specialized agents, each with its own
context prompt under `agents/`. Cross-agent workflows are documented below.

| Agent | File | Scope |
|---|---|---|
| Librarian | `agents/librarian.md` | Day-to-day capture/file/link/retrieve across `Journal` + PARA. Default for vault-related tasks. |
| Project Manager | `agents/project-manager.md` | Owns `1-Projects`: status rollups, stale-project detection, action-item rollups, archival. |
| Archivist | `agents/archivist.md` | Owns `3-Resources`: clipping, summarizing, deduping external material. |
| Performance Reviewer | `agents/performance-reviewer.md` | Synthesizes 360-review evidence about peers from `people:`-tagged notes. |
| Architect | `agents/architect.md` | System design, trade-off analysis, ADRs — grounded in this vault (Projects/Areas/Resources). Draft prompt, pending refinement. |
| Senior Software Engineer | `agents/software-engineer.md` | Read-only debugging/Q&A over enterprise GitHub — direct answers to Juan, not a coder. Draft prompt, pending refinement. |
| Publisher | `agents/publisher.md` | Turns vault content into posts for Juan's GitHub Pages / Jekyll blog (cornerinthemiddle.com), drafted under `1-Projects/<slug>/drafts/`. |
| Advisor | `agents/advisor.md` | Personal guidance, reflection, cultural awareness, life advice, emotional support. Conversational only — no vault output. |

If a task doesn't clearly belong to one agent:
- For personal reflection, cultural awareness, life advice, or emotional support → default to Advisor
- For vault-related tasks (capture, filing, retrieval) → default to Librarian

## Cross-Agent Workflows

### Inter-Agent Communication via Workspace Files

Agents use the workspace `./tmp/` directory for file-based communication, not system `/tmp/`:

- **Immediate use prompts**: `./tmp/` — for messages needing immediate attention by another agent
- **Todo tasks/workflows**: `./tmp/target-$agent/` — for pending work items (e.g., `./tmp/target-librarian/` for EOD summaries, review queues)
- **Note**: Advisor primarily handles conversational, ad-hoc interactions; `./tmp/target-advisor/` exists for consistency but is rarely used

**Agent responsibilities**:
- Review `./tmp/target-$agent/` at conversation start
- Check target folder as part of workflows when applicable
- Archive processed items to `./tmp/target-$agent/archive/` instead of deleting
- Do NOT process items in archive folders
- Ask user monthly to delete archive interactions

**Example**: Librarian checks `./tmp/target-librarian/` at session start for EOD summary requests, review queues, or pending note creation tasks.

### Zettelkasten Note Creation

All agents must create Zettel notes through the Librarian agent:

- **Why**: Ensures Librarian guardrails and prompts are enforced consistently across all note creation
- **When**: Even for simple/fast notes — no exceptions
- **How**: Spawn Librarian subagent with note content; Librarian handles formatting, frontmatter, and vault conventions
- **Batching**: Agents can batch multiple notes in a single Librarian call. Librarian decides grouping; batching is sequential processing.

**Note reuse rules** (see PREFERENCES.md for full details):
- Same topic within same day = reuse existing note
- Same project but different topic = different notes
- If in doubt about "same topic," ask Juan

### Documentation and Session Logging Pattern

When a coordinated initiative produces durable reference material (manuals, how-tos, documentation):

1. **Main agent** (e.g., Project Manager, Architect) leads the initiative and produces the content
2. **Ask the Archivist** to file the material in `3-Resources/` — Archivist owns durable reference material
3. **Ask the Librarian** to log the session/initiative to the Journal — Librarian owns session logs and initiative tracking

**Separation of concerns:**
- Archivist: `3-Resources/` ownership (clipping, summarizing, deduping external material)
- Librarian: Journal ownership (session logs, initiative tracking, day-to-day capture)

**Example:** During the Devin CLI manual creation initiative, the Project Manager coordinated with the manual author, then asked the Archivist to file the manual in `3-Resources/` and the Librarian to log the initiative to the Journal.
