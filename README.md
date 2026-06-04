# Deep Research Discovery

A Claude Code skill for comprehensive research requiring **50+ sources minimum** through systematic
parallel gathering, adversarial claim verification, and actionable direction synthesis.

**Core principle:** Breadth before depth. Gather comprehensively, verify claims, then narrow systematically.

> **v2.0.0 — now native.** This skill no longer depends on the **superpowers** plugin or the
> **google-ai-mode** Python skill. It runs entirely on first-party Claude Code capabilities:
> the `Agent` tool, dynamic `Workflow`s, built-in `WebSearch`/`WebFetch`, `AskUserQuestion`, and the
> file-based **memory** system. No plugins, no Python, no CAPTCHA.

## Features

- **8-phase research process** (Phase 0 recall+scope → Phase 7 persist) with built-in checkpoints
- **50+ source minimum** enforced through parallel agent / workflow dispatch
- **Shared agent memory** — dispatched agents collaborate via a shared `.deep-research/` workspace
- **Dynamic workflows** — optional `Workflow` orchestration for deterministic fan-out + verify pipeline
- **Adversarial claim verification** using native `WebSearch`/`WebFetch` (no external search skill)
- **Persistent memory** — finished reports are saved so future sessions recall instead of re-researching
- **User decision points** via `AskUserQuestion` before committing to directions
- **Structured output** with citations and evidence

## Quick Start

### Automated Installation (Recommended)

```bash
git clone https://github.com/HateBunnyPlzzz/deep-research-discovery-skill.git
cd deep-research-discovery-skill
./install.sh
```

The installer copies `SKILL.md` into `~/.claude/skills/deep-research-discovery/`. That's it — there are
no other dependencies to install.

### Manual Installation

```bash
git clone https://github.com/HateBunnyPlzzz/deep-research-discovery-skill.git \
  ~/.claude/skills/deep-research-discovery
```

Or just the skill file:

```bash
mkdir -p ~/.claude/skills/deep-research-discovery
curl -o ~/.claude/skills/deep-research-discovery/SKILL.md \
  https://raw.githubusercontent.com/HateBunnyPlzzz/deep-research-discovery-skill/main/SKILL.md
```

### Verify Installation

Start a **new** Claude Code session and run:

```
/deep-research-discovery
```

## Usage

### Invoke directly

```
/deep-research-discovery [topic or question]
```

### Or just ask for research

Claude uses this skill automatically when you request comprehensive research:

- "Research the current state of hand pose estimation"
- "Survey the literature on transformer architectures"
- "What are the best approaches for X in 2026?"
- "I need a comprehensive overview of [topic]"

## How It Works

### The 8-phase process

```
Phase 0  Recall + Scope        check MEMORY.md for prior research → AskUserQuestion to scope
Phase 1  Query Decomposition   generate 20-50 diverse search queries
Phase 2  Parallel Gathering    Workflow OR 5-10 parallel Agents → shared .deep-research/ workspace
                               Target: 50+ unique sources (MANDATORY)
Phase 3  Content Synthesis     build knowledge structure; surface contradictions & gaps
Phase 4  Direction ID          3-5 directions + comparison matrix → ⚠️ USER CHECKPOINT
Phase 5  Crystallization       detailed proposal for the chosen direction
Phase 6  Claim Verification    adversarial WebSearch/WebFetch verifier agents (Tier 1 + Tier 2)
Phase 7  Persist to Memory     save REPORT.md + a memory entry so future sessions recall it
```

### Harness features used

| Feature | Where | Purpose |
|---------|-------|---------|
| `Agent` tool (parallel subagents) | Phase 2, 6 | Concurrent source gathering & verification |
| Dynamic `Workflow` | Phase 2, 6 | Deterministic fan-out + dedup/verify pipeline |
| Shared agent memory (`.deep-research/`) | Phase 2-7 | Subagents collaborate via a shared workspace |
| `WebSearch` / `WebFetch` | Phase 2, 6 | Native search & fetch (replaces google-ai-mode) |
| `AskUserQuestion` | Phase 0, 4, 6 | Scoping and decision checkpoints |
| File-based memory + `MEMORY.md` | Phase 0, 7 | Recall prior research; persist new reports |

### The Iron Laws

```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃  NO RESEARCH COMPLETE WITHOUT 50+ SOURCES  ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃  NO CRITICAL CLAIM ACCEPTED WITHOUT VERIFY ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

## When to Use

**Use for:**
- Starting research in a new domain
- Literature survey / state-of-the-art review
- Strategic decisions requiring comprehensive information
- Understanding landscape before committing to direction

**Don't use for:**
- Quick lookups (use regular search)
- Single-source answers
- Implementation tasks

## Optional integrations (no longer required)

| Component | Status | Note |
|-----------|--------|------|
| superpowers plugin | Optional | `superpowers:writing-plans` can turn a verified proposal into a plan; the native `Plan` agent covers the same need. [obra/superpowers](https://github.com/obra/superpowers) |
| google-ai-mode skill | Optional | Only if you specifically want Google AI Mode search; native `WebSearch`/`WebFetch` is the default. [PleasePrompto/google-ai-mode-skill](https://github.com/PleasePrompto/google-ai-mode-skill) |

## Troubleshooting

### "Skill not found"
1. Verify the file exists: `ls ~/.claude/skills/deep-research-discovery/SKILL.md`
2. Start a **new** Claude Code session
3. Try `/deep-research-discovery` again

### Research stops before 50 sources
This shouldn't happen — the skill enforces the 50+ minimum. If it does, remind Claude:
"Continue gathering sources until you have 50+."

### Workflow won't run
The `Workflow` tool requires user opt-in. Either say "use a workflow" / "ultracode", or let the skill
fall back to hand-dispatched parallel `Agent` calls (Phase 2 — Agent mode) — both reach 50+ sources.

## Migrating from v1

If you previously installed v1, you can remove the old dependencies (they're now optional):
- The `google-ai-mode` skill is no longer used for verification.
- The `superpowers` plugin is no longer required to dispatch agents.

Re-run `./install.sh` (or re-clone) to get v2's `SKILL.md`, then start a new session.

## License

MIT License — see [LICENSE](LICENSE)

## Contributing

Issues and PRs welcome. Please ensure modifications maintain:
- The 50+ source requirement
- The adversarial claim-verification phase
- User checkpoints before direction selection
- Persistence to memory

## Credits

- Built for comprehensive research workflows in Claude Code.
- v1 integrations: **Superpowers** by [Jesse Vincent (obra)](https://github.com/obra),
  **Google AI Mode** by [PleasePrompto](https://github.com/PleasePrompto).
