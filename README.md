# Deep Research Discovery

A Claude Code skill for comprehensive research requiring **50+ sources minimum** through systematic parallel gathering, claim verification, and actionable direction synthesis.

**Core principle:** Breadth before depth. Gather comprehensively, verify claims, then narrow systematically.

## Features

- **6-phase research process** with built-in checkpoints
- **50+ source minimum** enforced through parallel agent dispatch
- **Automatic claim verification** using Google AI search
- **User decision points** before committing to directions
- **Structured output** with citations and evidence

## Quick Start

### Automated Installation (Recommended)

```bash
# Clone the repo
git clone https://github.com/HateBunnyPlzzz/deep-research-discovery-skill.git

# Run the installer
cd deep-research-discovery-skill
./install.sh
```

The installer will:
1. Check for all required dependencies
2. Install missing components automatically
3. Guide you through manual steps (for Claude Code plugins)

### Manual Installation

If you prefer manual installation, follow these steps in order:

#### Step 1: Install Superpowers Plugin (Required)

**In Claude Code, run:**
```
/plugin marketplace add superpowers-marketplace/superpowers
/plugin install superpowers@superpowers-marketplace
```

**GitHub:** https://github.com/obra/superpowers

This provides:
- `superpowers:brainstorming` - Scope research questions
- `superpowers:dispatching-parallel-agents` - Parallel agent dispatch (Phase 2)
- `superpowers:writing-plans` - Execution planning

#### Step 2: Install Google AI Mode Skill (Required)

```bash
git clone https://github.com/PleasePrompto/google-ai-mode-skill.git ~/.claude/skills/google-ai-mode
```

**GitHub:** https://github.com/PleasePrompto/google-ai-mode-skill

This provides claim verification in Phase 6.

#### Step 3: Install Deep Research Discovery Skill

```bash
git clone https://github.com/HateBunnyPlzzz/deep-research-discovery-skill.git ~/.claude/skills/deep-research-discovery
```

Or manually:
```bash
mkdir -p ~/.claude/skills/deep-research-discovery
curl -o ~/.claude/skills/deep-research-discovery/SKILL.md \
  https://raw.githubusercontent.com/HateBunnyPlzzz/deep-research-discovery-skill/main/SKILL.md
```

### Verify Installation

Start a new Claude Code session and run:
```
/deep-research-discovery
```

Claude should recognize and load the skill.

## Installation Checklist

- [ ] Superpowers plugin marketplace added (`/plugin marketplace add superpowers-marketplace/superpowers`)
- [ ] Superpowers plugin installed (`/plugin install superpowers@superpowers-marketplace`)
- [ ] Google AI Mode skill cloned to `~/.claude/skills/google-ai-mode/`
- [ ] Deep Research Discovery skill in `~/.claude/skills/deep-research-discovery/`
- [ ] New Claude Code session started
- [ ] `/deep-research-discovery` command recognized

## Dependencies

| Dependency | Required | Purpose | GitHub |
|------------|----------|---------|--------|
| `superpowers:brainstorming` | **Strongly recommended** | Scope research question BEFORE this skill | [obra/superpowers](https://github.com/obra/superpowers) |
| `superpowers:dispatching-parallel-agents` | **Yes** | Parallel agent dispatch in Phase 2 | [obra/superpowers](https://github.com/obra/superpowers) |
| `google-ai-mode` | **Yes** | Claim verification in Phase 6 | [PleasePrompto/google-ai-mode-skill](https://github.com/PleasePrompto/google-ai-mode-skill) |
| `superpowers:writing-plans` | Optional | Execution planning after Phase 6 | [obra/superpowers](https://github.com/obra/superpowers) |

## Usage

### Recommended Workflow

**Always brainstorm before researching:**

```
1. /superpowers:brainstorming     →  Scope the research question first
2. /deep-research-discovery       →  Gather 50+ sources + verify claims
3. /superpowers:writing-plans     →  Create execution plan (optional)
```

**Why brainstorm first?** It clarifies what you actually need to research, prevents wasted effort, and identifies hidden assumptions.

### Invoke Directly

```
/deep-research-discovery
```

### Or Ask for Research

Claude will automatically use this skill when you request comprehensive research:

- "Research the current state of hand pose estimation"
- "Survey the literature on transformer architectures"
- "What are the best approaches for X in 2025?"
- "I need a comprehensive overview of [topic]"

## How It Works

### The 6-Phase Process

```
┌─────────────────────────────────────────────────────────────────┐
│  Phase 1: Query Decomposition                                   │
│  Generate 20-50 diverse search queries                          │
│  Categories: foundational, SOTA, methods, comparisons,          │
│              problems, applications, tools, key players         │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│  Phase 2: Parallel Source Gathering                             │
│  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐                       │
│  │Agent│ │Agent│ │Agent│ │Agent│ │Agent│  5-10 agents          │
│  │  1  │ │  2  │ │  3  │ │  4  │ │  5  │  in parallel          │
│  └─────┘ └─────┘ └─────┘ └─────┘ └─────┘                       │
│  Uses: superpowers:dispatching-parallel-agents                  │
│  Target: 50+ unique sources (MANDATORY)                         │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│  Phase 3: Content Synthesis                                     │
│  Build knowledge structure from all sources                     │
│  Identify contradictions, gaps, key players, breakthroughs      │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│  Phase 4: Direction Identification                              │
│  Extract 3-5 actionable research directions                     │
│  Comparison matrix: feasibility / novelty / impact / risk       │
│  ⚠️  USER CHECKPOINT - You choose the direction                 │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│  Phase 5: Actionable Crystallization                            │
│  Detailed proposal for chosen direction                         │
│  Concrete first steps + risk mitigations                        │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│  Phase 6: Claim Verification (Tiered)                           │
│  Uses: google-ai-mode skill                                     │
│  Tier 1: Auto-verify ALL critical claims                        │
│  Tier 2: USER CHECKPOINT - Choose to verify more claims         │
│          Options: Important claims / All claims / Done          │
└─────────────────────────────────────────────────────────────────┘
```

### The Iron Laws

```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃  NO RESEARCH COMPLETE WITHOUT 50+ SOURCES  ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃  NO CLAIMS ACCEPTED WITHOUT VERIFICATION   ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

No exceptions. This skill enforces comprehensive research with verified claims.

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

## Troubleshooting

### "Skill not found"

1. Verify the skill file exists: `ls ~/.claude/skills/deep-research-discovery/SKILL.md`
2. Start a new Claude Code session
3. Try `/deep-research-discovery` again

### "dispatching-parallel-agents not found"

The superpowers plugin isn't installed. Run in Claude Code:
```
/plugin marketplace add superpowers-marketplace/superpowers
/plugin install superpowers@superpowers-marketplace
```

### "google-ai-mode not found" / Verification phase fails

The Google AI Mode skill isn't installed:
```bash
git clone https://github.com/PleasePrompto/google-ai-mode-skill.git ~/.claude/skills/google-ai-mode
```

### Google AI Mode CAPTCHA issues

First-time setup may require solving a CAPTCHA:
```bash
cd ~/.claude/skills/google-ai-mode
python scripts/run.py search.py --query "test query" --show-browser
```
Solve the CAPTCHA once, then future searches work automatically.

### Research stops before 50 sources

This shouldn't happen — the skill enforces the 50+ source minimum. If it does, invoke the skill again and remind Claude: "Continue gathering sources until you have 50+."

## GitHub Repositories

| Component | Repository |
|-----------|------------|
| Deep Research Discovery | [HateBunnyPlzzz/deep-research-discovery-skill](https://github.com/HateBunnyPlzzz/deep-research-discovery-skill) |
| Superpowers Plugin | [obra/superpowers](https://github.com/obra/superpowers) |
| Google AI Mode Skill | [PleasePrompto/google-ai-mode-skill](https://github.com/PleasePrompto/google-ai-mode-skill) |

## License

MIT License - see [LICENSE](LICENSE)

## Contributing

Issues and PRs welcome. Please ensure any modifications maintain:
- The 50+ source requirement
- The claim verification phase
- User checkpoints before direction selection

## Credits

- **Superpowers** by [Jesse Vincent (obra)](https://github.com/obra)
- **Google AI Mode** by [PleasePrompto](https://github.com/PleasePrompto)
- Built for comprehensive research workflows in Claude Code
