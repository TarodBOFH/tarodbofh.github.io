---
id: 202609101500
project: setup-agentic-software-director-workspace
status: draft
created: 2026-09-10
url:
# --- Jekyll / minimal-mistakes front matter below: copied as-is at publish time ---

title: "Building an Agentic Knowledge Vault with PARA and Zettelkasten"
excerpt: "How I combined PARA organization with Zettelkasten atomic notes, then wired it up with specialized AI agents for consistent knowledge management."
date: 2026-09-10
categories: [Software Engineering, AI]
tags: [knowledge-management, PARA, Zettelkasten, AI-agents, productivity]
toc: false
toc_sticky: true
header:
    teaser:        /assets/images/posts/agentic-knowledge-vault-setup/ai-agent-names.jpg
    overlay_image: /assets/images/posts/agentic-knowledge-vault-setup/background.jpg
    overlay_filter: 0.25
classes: wide
---

# Building an Agentic Knowledge Vault with PARA and Zettelkasten

Sometimes we struggle with information overload—meetings, decisions, projects, and reference material scattered across tools with no durable, searchable home. As a Software Director, I needed a system that could handle this complexity while staying within company policy (no external note-taking apps allowed). So I built an agentic knowledge vault combining PARA and Zettelkasten, then wired it up with specialized AI agents.

## The Setup: PARA + Zettelkasten

I started with two complementary knowledge management methods: PARA for organization by actionability, and Zettelkasten for atomic note-taking.

**PARA (Projects, Areas, Resources, Archive)** gives me a structure based on how I actually work:
- `0-Inbox/` for unsorted fleeting notes awaiting triage
- `1-Projects/` for active projects with defined outcomes and deadlines  
- `2-Areas/` for ongoing responsibilities with no end date
- `3-Resources/` for reference material and topics of ongoing interest
- `4-Archive/` for inactive items (mirrors the live PARA structure)

**Zettelkasten** gives me atomic notes—one idea per note, filed by creation date in `Journal/YYYY/MM/YYYY-MM-DD/<id>.md`. Each note uses timestamp-based IDs for uniqueness and links upward to PARA contexts via YAML frontmatter arrays.

The key insight: a single atomic idea in the Journal can simultaneously support multiple projects, feed standing areas of responsibility, and reference resources. One idea, many contexts.

## Adding Agents: The Agentic Layer

Here's where it gets interesting. I didn't just want a static knowledge base—I wanted it to be alive, maintained by specialized AI agents that understand both the structure and my working preferences.

I created a roster of specialized agents, each with a dedicated context file defining scope, responsibilities, and constraints:

**Core Vault Agents:**
- **Librarian**: Day-to-day vault operations—capture, file, link, and retrieve notes. The default agent for vault-related tasks.
- **Project Manager**: Owns `1-Projects/`—status rollups, stale-project detection, action-item aggregation, project archival.
- **Archivist**: Owns `3-Resources/`—clipping external material, summarizing, deduping, filing durable reference material.
- **Performance Reviewer**: Synthesizes 360-degree reviews from `people:`-tagged notes.

**Technical Agents:**
- **Architect**: System design, trade-off analysis, design docs—reasons from vault content about what *should* be built.
- **Senior Software Engineer**: Read-only debugging/Q&A over enterprise GitHub—reasons from actual code about what *is* built and why it's broken.
- **Publisher**: Turns vault content into blog posts (like this one!) for my GitHub Pages site.

**Personal Agent:**
- **Advisor**: Personal guidance, reflection, cultural awareness, life advice. Conversational only—no vault output.

## What Makes It "Agentic"

The system isn't just a bunch of AI personas—it's a coordinated workflow with clear separation of concerns:

1. **Shared Preferences Layer**: `PREFERENCES.md` is the master file all agents read first, containing my communication style (Amazon-style: direct, concise, data-backed), decision logging conventions, and inter-agent communication patterns.

2. **Fixed Reference Resolution**: No agentic inference needed for links. Field names map to file locations via static rules—`project: <slug>` checks `1-Projects/<slug>.md`, then folder form, then Archive. Links don't break when projects are archived.

3. **Plain Markdown + YAML Frontmatter**: Everything stays in git-tracked Markdown files that work across tools—VS Code, GitHub, Devin. No external note-taking app required.

4. **Cross-Agent Coordination**: Agents coordinate through the `./tmp/` directory for file-based communication. When the Architect completes an architecture extraction, they document it in `./tmp/target-librarian/` for the Librarian to log to the Journal.

## The Learning Curve: Agent Interactions

{% include figure image_path="/assets/images/posts/agentic-knowledge-vault-setup/ai-agent-names.jpg" alt="Image showing robots fighting about how they want to be called" caption="Call me Nexus!" %}

Setting this up wasn't without its amusing moments. My own bias to categorize agents led me to ask for names, and the agents had a debate within themselves with repeated names due to their training. I ended up with a "Librarian" instead of a "Secretary" to avoid gendered stereotypes.

I was genuinely surprised the first time one agent interacted with another freely. The Architect handed off to the Librarian seamlessly, and I realized this wasn't just a set of independent tools—it was a coordinated system.

The Librarian guardrails were particularly entertaining. The first time I asked Nexus (the name the Librarian gave to him/herself) to change the name of a session, Nexus just created a Zettel note saying "Juan wants to change this session title" and nothing more. Strict adherence to guardrails, I suppose.

## Key Implementation Details

**Agent Coordination Pattern**: When a coordinated initiative produces durable reference material, the main agent leads the initiative and produces the content, then asks the Archivist to file it in `3-Resources/` and the Librarian to log the session to the Journal. This prevents ownership conflicts and ensures each type of content has a clear home.

**Zettel Note Creation Gatekeeper**: All agents must create Zettel notes through the Librarian agent. This ensures consistent formatting, frontmatter, and vault conventions. Same topic within same day? Reuse the existing note—efficiency for async work.

**Technical Stack**: The vault uses git-backed storage with GitHub remote, Devin blueprint auto-detection from `main` branch, and GPG-signed commits for authentication. Everything runs on what's already available—no additional software installation required.

**Prompt Architecture**: The agent prompts use a three-layer hierarchy. `PREFERENCES.md` is the master file all agents read first—containing communication style, decision logging conventions, and working preferences. `AGENTS.md` serves as the central roster and workflow reference. Individual agent contexts live in `agents/*.md` files (one per role), loaded via Devin skills that act as thin wrappers pointing to the full context. This static file approach means no dynamic discovery—agents read from known absolute paths, keeping everything predictable and git-tracked.

**Self-Updating Prompts**: Here's where it gets meta. The agents actually update their own prompts based on my feedback. When I noticed they were trying to use Homebrew for software installation (which doesn't work well in corporate environments), the Architect analyzed the situation and updated `PREFERENCES.md` with explicit guidance to prefer vendor-provided installation methods. After successfully configuring the Atlassian MCP integration, the Architect added an "MCP Server Status" section to its own prompt file with troubleshooting guidance for other agents. Whenever I saw changes to `PREFERENCES.md` or agent files, I was curious and amused reading the updates—they were essentially learning and adapting in real-time.

## What I've Learned

Building this system taught me that knowledge management isn't just about tools—it's about workflows and constraints. The PARA structure gives me organization by actionability. Zettelkasten gives me atomic ideas that can connect to multiple contexts. The agents give me consistent maintenance without me having to remember all the rules.

The agents don't just follow instructions—they have guardrails. The Librarian never guesses when a rule is ambiguous. The Archivist summarizes rather than dumping full text. The Publisher never publishes without my explicit approval. These constraints make the system reliable rather than unpredictable.

## Getting Started

If you're interested in building something similar, start with the structure:
1. Set up PARA folders for organization by actionability
2. Add a Journal for atomic Zettelkasten notes with timestamp IDs
3. Create a master preferences file that all agents read first
4. Define agent roles with clear scope and constraints
5. Build coordination patterns (file-based communication works well)

The key insight: specialized agents with clear boundaries beat general-purpose assistants every time. My Librarian doesn't try to be an Architect, and my Architect doesn't try to be a Publisher. They stay in their lanes and hand off when appropriate.

## Next Steps

I'm still refining the system—deciding whether `people` needs a backing profile file, whether Publisher gets push access to the blog repo, and how to handle more complex cross-agent workflows. But the foundation is solid: PARA + Zettelkasten + specialized agents = a knowledge vault that actually stays maintained.

Sometimes the best systems are the ones that get out of your way and let you focus on the work, not the maintenance. This one's getting there.

## Resource Examples / Prompts

[Context / Knowledge Vault README.md](/assets/agentic-knowledge-vault-setup/README.md)
[Shared Preferences Prompt](/assets/agentic-knowledge-vault-setup/PREFERENCES.md)
[Agents / Collaboration Prompt](/assets/agentic-knowledge-vault-setup/AGENTS.md)
