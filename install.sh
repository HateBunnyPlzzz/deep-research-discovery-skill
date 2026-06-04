#!/bin/bash

# Deep Research Discovery Skill Installer (v2 — native harness)
# Installs the skill into ~/.claude/skills. No external plugins or Python required:
# the skill now runs on first-party Claude Code tools (Agent, Workflow, WebSearch/WebFetch, memory).

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     Deep Research Discovery Skill Installer (v2)          ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DEST_DIR="$HOME/.claude/skills/deep-research-discovery"

command_exists() { command -v "$1" >/dev/null 2>&1; }

# Compute a portable md5 hash (macOS uses `md5 -q`, Linux uses `md5sum`)
hash_file() {
    md5 -q "$1" 2>/dev/null || md5sum "$1" | cut -d' ' -f1
}

echo -e "${YELLOW}Checking prerequisites...${NC}"
if ! command_exists git; then
    echo -e "${YELLOW}○ Git not found (optional — only needed to clone). Continuing with local copy.${NC}"
else
    echo -e "${GREEN}✓ Git is installed${NC}"
fi
echo ""

# Decide install vs update
ACTION="install"
if [ -f "$DEST_DIR/SKILL.md" ]; then
    if [ -f "$SCRIPT_DIR/SKILL.md" ] && [ "$(hash_file "$SCRIPT_DIR/SKILL.md")" = "$(hash_file "$DEST_DIR/SKILL.md")" ]; then
        echo -e "${GREEN}✓ Deep Research Discovery skill is already installed and up to date.${NC}"
        echo ""
        echo -e "${BLUE}Usage:${NC} start a new Claude Code session and run /deep-research-discovery"
        exit 0
    fi
    ACTION="update"
fi

if [ "$ACTION" = "update" ]; then
    echo -e "${BLUE}  Updating Deep Research Discovery Skill${NC}"
else
    echo -e "${BLUE}  Installing Deep Research Discovery Skill${NC}"
fi
echo ""

mkdir -p "$DEST_DIR"

if [ -f "$SCRIPT_DIR/SKILL.md" ]; then
    cp "$SCRIPT_DIR/SKILL.md" "$DEST_DIR/"
    echo -e "${GREEN}✓ Deep Research Discovery skill ${ACTION}ed${NC}"
else
    echo -e "${YELLOW}SKILL.md not found locally — downloading from GitHub...${NC}"
    curl -sL -o "$DEST_DIR/SKILL.md" \
        "https://raw.githubusercontent.com/HateBunnyPlzzz/deep-research-discovery-skill/main/SKILL.md"
    if [ -f "$DEST_DIR/SKILL.md" ]; then
        echo -e "${GREEN}✓ Deep Research Discovery skill downloaded${NC}"
    else
        echo -e "${RED}✗ Failed to download skill${NC}"
        exit 1
    fi
fi

echo ""
echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                    Installation Complete                   ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}✓${NC} Installed to: $DEST_DIR/SKILL.md"
echo -e "${GREEN}✓${NC} No external plugins or Python required."
echo ""
echo -e "${BLUE}Usage:${NC}"
echo "  1. Start a NEW Claude Code session (required to load the skill)"
echo "  2. Run: /deep-research-discovery  (or just ask Claude to 'research [topic]')"
echo ""
echo -e "${YELLOW}Important: you must start a NEW session for the skill to be recognized.${NC}"
echo ""
echo -e "${BLUE}GitHub:${NC} https://github.com/HateBunnyPlzzz/deep-research-discovery-skill"
echo ""
