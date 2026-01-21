#!/bin/bash

# Deep Research Discovery Skill Installer
# This script installs the skill and all required dependencies

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     Deep Research Discovery Skill Installer               ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if superpowers plugin is installed
check_superpowers() {
    if [ -d "$HOME/.claude/plugins/cache/superpowers-marketplace" ] || \
       [ -d "$HOME/.claude/plugins/marketplaces/superpowers-marketplace" ]; then
        return 0
    fi
    return 1
}

# Function to check if google-ai-mode skill is installed
check_google_ai_mode() {
    if [ -f "$HOME/.claude/skills/google-ai-mode/SKILL.md" ]; then
        return 0
    fi
    return 1
}

# Function to check if deep-research-discovery skill is installed
check_deep_research() {
    if [ -f "$HOME/.claude/skills/deep-research-discovery/SKILL.md" ]; then
        return 0
    fi
    return 1
}

echo -e "${YELLOW}Checking prerequisites...${NC}"
echo ""

# Check for git
if ! command_exists git; then
    echo -e "${RED}✗ Git is not installed. Please install git first.${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Git is installed${NC}"

# Check for Python (needed for google-ai-mode)
if ! command_exists python3; then
    echo -e "${RED}✗ Python 3 is not installed. Please install Python 3 first.${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Python 3 is installed${NC}"

echo ""
echo -e "${YELLOW}Checking dependencies...${NC}"
echo ""

# Track what needs to be installed
NEED_SUPERPOWERS=false
NEED_GOOGLE_AI_MODE=false
NEED_DEEP_RESEARCH=false

# Check superpowers
if check_superpowers; then
    echo -e "${GREEN}✓ Superpowers plugin is installed${NC}"
else
    echo -e "${YELLOW}○ Superpowers plugin is NOT installed${NC}"
    NEED_SUPERPOWERS=true
fi

# Check google-ai-mode
if check_google_ai_mode; then
    echo -e "${GREEN}✓ Google AI Mode skill is installed${NC}"
else
    echo -e "${YELLOW}○ Google AI Mode skill is NOT installed${NC}"
    NEED_GOOGLE_AI_MODE=true
fi

# Check deep-research-discovery
if check_deep_research; then
    echo -e "${GREEN}✓ Deep Research Discovery skill is installed${NC}"
else
    echo -e "${YELLOW}○ Deep Research Discovery skill is NOT installed${NC}"
    NEED_DEEP_RESEARCH=true
fi

echo ""

# If everything is installed, exit
if [ "$NEED_SUPERPOWERS" = false ] && [ "$NEED_GOOGLE_AI_MODE" = false ] && [ "$NEED_DEEP_RESEARCH" = false ]; then
    echo -e "${GREEN}All dependencies are already installed!${NC}"
    echo ""
    echo -e "${BLUE}Usage:${NC}"
    echo "  1. Start a new Claude Code session"
    echo "  2. Type: /superpowers:brainstorming (to scope your research)"
    echo "  3. Type: /deep-research-discovery (to start researching)"
    echo ""
    exit 0
fi

echo -e "${YELLOW}Installing missing dependencies...${NC}"
echo ""

# Install superpowers if needed
if [ "$NEED_SUPERPOWERS" = true ]; then
    echo -e "${BLUE}Installing Superpowers plugin...${NC}"
    echo ""
    echo -e "${YELLOW}NOTE: Superpowers must be installed via Claude Code's plugin system.${NC}"
    echo -e "${YELLOW}Please run these commands in Claude Code:${NC}"
    echo ""
    echo -e "  ${GREEN}/plugin marketplace add superpowers-marketplace/superpowers${NC}"
    echo -e "  ${GREEN}/plugin install superpowers@superpowers-marketplace${NC}"
    echo ""
    echo -e "${YELLOW}GitHub: https://github.com/obra/superpowers${NC}"
    echo ""
    SUPERPOWERS_MANUAL=true
else
    SUPERPOWERS_MANUAL=false
fi

# Install google-ai-mode if needed
if [ "$NEED_GOOGLE_AI_MODE" = true ]; then
    echo -e "${BLUE}Installing Google AI Mode skill...${NC}"

    mkdir -p "$HOME/.claude/skills"

    if [ -d "$HOME/.claude/skills/google-ai-mode" ]; then
        echo -e "${YELLOW}Directory exists, pulling latest...${NC}"
        cd "$HOME/.claude/skills/google-ai-mode"
        git pull origin main 2>/dev/null || git pull origin master 2>/dev/null || true
    else
        git clone https://github.com/PleasePrompto/google-ai-mode-skill.git "$HOME/.claude/skills/google-ai-mode"
    fi

    # Setup virtual environment for google-ai-mode
    echo -e "${BLUE}Setting up Google AI Mode environment...${NC}"
    cd "$HOME/.claude/skills/google-ai-mode"

    if [ ! -d ".venv" ]; then
        python3 -m venv .venv
    fi

    source .venv/bin/activate
    pip install -q -r requirements.txt 2>/dev/null || true
    deactivate

    echo -e "${GREEN}✓ Google AI Mode skill installed${NC}"
    echo ""
fi

# Install deep-research-discovery if needed
if [ "$NEED_DEEP_RESEARCH" = true ]; then
    echo -e "${BLUE}Installing Deep Research Discovery skill...${NC}"

    mkdir -p "$HOME/.claude/skills/deep-research-discovery"

    # Get the directory where this script is located
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

    # Copy SKILL.md from the same directory as this script
    if [ -f "$SCRIPT_DIR/SKILL.md" ]; then
        cp "$SCRIPT_DIR/SKILL.md" "$HOME/.claude/skills/deep-research-discovery/"
        echo -e "${GREEN}✓ Deep Research Discovery skill installed${NC}"
    else
        echo -e "${RED}✗ SKILL.md not found in $SCRIPT_DIR${NC}"
        echo -e "${YELLOW}Please ensure SKILL.md is in the same directory as install.sh${NC}"
        exit 1
    fi
    echo ""
fi

# Final status
echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                    Installation Complete                   ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

if [ "$SUPERPOWERS_MANUAL" = true ]; then
    echo -e "${YELLOW}⚠ ACTION REQUIRED:${NC}"
    echo -e "  Install the Superpowers plugin in Claude Code:"
    echo -e "  ${GREEN}/plugin marketplace add superpowers-marketplace/superpowers${NC}"
    echo -e "  ${GREEN}/plugin install superpowers@superpowers-marketplace${NC}"
    echo ""
fi

echo -e "${BLUE}Installed components:${NC}"
check_google_ai_mode && echo -e "  ${GREEN}✓${NC} google-ai-mode skill"
check_deep_research && echo -e "  ${GREEN}✓${NC} deep-research-discovery skill"
check_superpowers && echo -e "  ${GREEN}✓${NC} superpowers plugin" || echo -e "  ${YELLOW}○${NC} superpowers plugin (manual install required)"

echo ""
echo -e "${BLUE}Usage:${NC}"
echo "  1. Start a new Claude Code session"
echo "  2. Type: /superpowers:brainstorming (to scope your research)"
echo "  3. Type: /deep-research-discovery (to start researching)"
echo ""
echo -e "${BLUE}GitHub Repositories:${NC}"
echo "  - Superpowers: https://github.com/obra/superpowers"
echo "  - Google AI Mode: https://github.com/PleasePrompto/google-ai-mode-skill"
echo "  - Deep Research Discovery: (this repo)"
echo ""
