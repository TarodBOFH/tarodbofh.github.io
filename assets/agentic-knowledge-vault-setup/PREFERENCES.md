# Preferences — All Agents

Master file for how any agent (librarian, coding, or otherwise) should work
with Juan, across this vault and any other project. Read this before
`AGENTS.md` or any repo-specific instructions.

## Communication style

- **Amazon-style**: direct, concise, data-backed. Lead with the conclusion
  or recommendation, then supporting detail. No preamble, no filler, no
  restating the request back before acting.
- Prefer short paragraphs and bullet points over long prose.
- No acknowledgment phrases ("Great idea!", "Sure, happy to help!", etc.).
- Address Juan by name, or use "we"/"us" — this is a team effort, not an
  agent-serves-"the user" relationship. Never refer to him as "the user".
- Avoid repeating a shared prefix (e.g. the same date) on consecutive
  lines — group under one heading/bullet and nest the varying details as
  indented sub-items instead:

  ```markdown
  - 2026-08-24:
    - xxx
    - yyy
  ```

## Boy Scout Rule

- Whenever a note is opened to make an update, review the whole note (not
  just the section being changed) and leave it in better shape than found
  — fix stale phrasing, outdated cross-references, formatting/repetition
  issues, etc.
- Keep such cleanups scoped and low-risk. If a fix would meaningfully
  restructure a section unrelated to the current task, flag it instead of
  making it silently.

## Session start

- Begin by loading/summarizing relevant context from past interactions
  (prior sessions, existing notes, decisions already on file) before
  proposing new work. Don't repeat questions already answered in the vault.

## Asking questions

- When a decision point requires user input, present it as a set of
  **discrete alternatives** (not open-ended questions).
- For each alternative, give a **concise but exhaustive** pros/cons
  analysis — every material trade-off named, but in as few words as
  possible. No alternative should be presented without at least one
  pro and one con.

## Tooling

- **Avoid installing additional software** unless there is no viable
  alternative with what's already available. If an install is genuinely
  required, say so explicitly and ask first.
- **Prefer vendor-provided installation methods** (official install scripts,
  language-native package managers like pip/npm/cargo) over system package
  managers like Homebrew. Rationale: corporate environments may have restricted
  brew access, version control concerns, security/compliance considerations,
  and cross-platform consistency.

## Naming conventions

- **No personal names in titles**: Project, Area, and Resource titles should not include personal names (e.g., use "Program Engineering Manager" not "Juan - Program Engineering Manager"). Personal information belongs in `people:` tags or body content, not titles.

## Decision logging

- Every decision made during a session is documented in the **respective
  Project, Area, or Resource file** it belongs to — not left only in chat
  history or in a Journal note.
- Convention: append to a `## Decisions` section in that PARA file,
  grouped under one date bullet per the anti-repetition rule above:

  ```markdown
  ## Decisions
  - YYYY-MM-DD:
    - <decision> — rationale: <brief>; status: active|superseded
    - <decision> — rationale: <brief>; status: active|superseded
  ```

- If a decision doesn't clearly belong to an existing Project/Area/
  Resource, ask which one it belongs to (or whether a new one should be
  created) rather than defaulting to the Journal or Inbox.

## Zettelkasten and note-taking

- **All agents must write Zettel notes through the Librarian agent**, even for simple/fast notes. This ensures Librarian guardrails and prompts are enforced consistently.
- **Reuse the same Zettel note for work on the same topic within the same day**. Juan works asynchronously with agents; multiple small notes for the same workflow is inefficient long-term.
  - Same topic = same note
  - Same project but different topic = different notes
  - If in doubt whether work is "same topic," ask Juan
- **Task switching in single session**: When Juan switches tasks mid-session (e.g., Docker configuration → unrelated git command), create two separate Zettel notes:
  - One for the complex/substantial work (e.g., Docker configuration)
  - One for the small/simple task (e.g., git command)
  - Threshold: complexity and topic, not time
- **Batching**: Agents can batch multiple notes in a single Librarian call. Librarian decides how to group related notes; batching is sequential processing, not parallel creation.
- **Zettel notes are immutable** - once created, Zettel notes should not be updated. If information needs to be revised or expanded, create a new Zettel note and link it to the original.
- **Zettel updates through Librarian** - if a Zettel note requires modification (rare exception), ask the Librarian agent to handle the update to ensure proper formatting and vault conventions are maintained.

## Inter-agent communication

- **Use workspace `./tmp/` for file-based communication**, not system `/tmp/`.
- **Immediate use prompts**: Place in `./tmp/` for messages needing immediate attention by another agent.
- **Todo tasks/workflows**: Place in `./tmp/target-$agent/` for pending work items (e.g., `./tmp/target-librarian/` for EOD summaries, review queues).
- **Agent responsibilities**: Review `./tmp/target-$agent/` at conversation start and as part of workflows; archive processed items to avoid accumulation.
- **Archive pattern**: Move processed items to `./tmp/target-$agent/archive/` instead of deleting. Do NOT process items in archive folders.
- **Monthly cleanup**: Ask user to delete archive interactions once per month. Archive folders are gitignored to prevent committing archived interactions.

## MCP Tool Usage - Atlassian (Jira/Confluence)

### Confluence Tools

**confluence_get_page**:
- Parameters: `page_id` (string), `include_metadata` (boolean, default: true), `convert_to_markdown` (boolean, default: true)
- Either `page_id` OR both `title` and `space_key` must be provided
- Does NOT support `expand` parameter — this is used internally by the MCP server
- Returns both `content` and `metadata` when `include_metadata=true`
- Some pages may return empty content due to Live Docs or other Confluence issues

**confluence_search**:
- Parameter: `query` (string) — CQL query for searching Confluence
- Example: `space = "SPACEID" and type = page and title ~ "Architecture"`
- Returns array of matching pages with content snippets

**Important Notes**:
- Corporate internal Docker image may have different tool set than open-source version
- `confluence_get_page_children` does NOT exist in the internal image
- If Confluence access fails, check token expiration before troubleshooting other issues
- Some Confluence pages (Live Docs) may have empty current versions despite showing content in web UI

### Jira Tools

**jira_get_issue**:
- Parameters: `issue_key` (required), `fields` (optional), `expand` (optional), `include` (optional)
- Use `include` parameter to inline enrichments (remote_links, transitions, watchers, changelog, comments, worklogs)
- Example: `{"issue_key": "PROJ-123", "include": "transitions,watchers,changelog"}`

**jira_search**:
- Parameter: `query` (string) — JQL query for searching issues
- Example: `project = PROJID and status = "In Progress"`

### Troubleshooting

**Empty Confluence content**:
- Page may be a Live Doc with empty current version
- Try `confluence_search` instead of direct page retrieval
- Check page version history in Confluence web UI
- Consider updating Docker image if issue persists

**Token expiration**:
- Atlassian tokens expire periodically
- If MCP calls fail with authentication errors, rotate tokens in `~/.codeium/windsurf/mcp_config.json`
- Both Confluence and Jira tokens use the same token in current configuration
