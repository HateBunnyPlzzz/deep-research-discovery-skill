#!/bin/bash

# Deep Research Discovery Skill Installer
# This script installs the skill and all required dependencies
# It's smart about detecting existing installations and updates

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

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

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

# Function to check if deep-research-discovery needs update
needs_update() {
    if [ ! -f "$SCRIPT_DIR/SKILL.md" ]; then
        return 1  # No source to compare
    fi

    if [ ! -f "$HOME/.claude/skills/deep-research-discovery/SKILL.md" ]; then
        return 0  # Not installed, needs "update" (install)
    fi

    # Compare file sizes as a simple version check
    local source_size=$(wc -c < "$SCRIPT_DIR/SKILL.md")
    local installed_size=$(wc -c < "$HOME/.claude/skills/deep-research-discovery/SKILL.md")

    if [ "$source_size" != "$installed_size" ]; then
        return 0  # Different sizes, needs update
    fi

    # Compare checksums for definitive check
    local source_hash=$(md5 -q "$SCRIPT_DIR/SKILL.md" 2>/dev/null || md5sum "$SCRIPT_DIR/SKILL.md" | cut -d' ' -f1)
    local installed_hash=$(md5 -q "$HOME/.claude/skills/deep-research-discovery/SKILL.md" 2>/dev/null || md5sum "$HOME/.claude/skills/deep-research-discovery/SKILL.md" | cut -d' ' -f1)

    if [ "$source_hash" != "$installed_hash" ]; then
        return 0  # Different content, needs update
    fi

    return 1  # Same version
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

# Track what needs action
ACTION_SUPERPOWERS="none"
ACTION_GOOGLE_AI_MODE="none"
ACTION_DEEP_RESEARCH="none"

# Check superpowers
if check_superpowers; then
    echo -e "${GREEN}✓ Superpowers plugin is installed${NC}"
else
    echo -e "${YELLOW}○ Superpowers plugin is NOT installed${NC}"
    ACTION_SUPERPOWERS="install"
fi

# Check google-ai-mode
if check_google_ai_mode; then
    echo -e "${GREEN}✓ Google AI Mode skill is installed${NC}"
else
    echo -e "${YELLOW}○ Google AI Mode skill is NOT installed${NC}"
    ACTION_GOOGLE_AI_MODE="install"
fi

# Check deep-research-discovery
if check_deep_research; then
    if needs_update; then
        echo -e "${YELLOW}↻ Deep Research Discovery skill needs UPDATE${NC}"
        ACTION_DEEP_RESEARCH="update"
    else
        echo -e "${GREEN}✓ Deep Research Discovery skill is installed (up to date)${NC}"
    fi
else
    echo -e "${YELLOW}○ Deep Research Discovery skill is NOT installed${NC}"
    ACTION_DEEP_RESEARCH="install"
fi

echo ""

# If everything is installed and up to date, exit
if [ "$ACTION_SUPERPOWERS" = "none" ] && [ "$ACTION_GOOGLE_AI_MODE" = "none" ] && [ "$ACTION_DEEP_RESEARCH" = "none" ]; then
    echo -e "${GREEN}All dependencies are installed and up to date!${NC}"
    echo ""
    echo -e "${BLUE}Usage:${NC}"
    echo "  1. Start a new Claude Code session"
    echo "  2. Type: /superpowers:brainstorming (to scope your research)"
    echo "  3. Type: /deep-research-discovery (to start researching)"
    echo ""
    exit 0
fi

echo -e "${YELLOW}Processing required actions...${NC}"
echo ""

# Handle superpowers if needed
if [ "$ACTION_SUPERPOWERS" = "install" ]; then
    echo -e "${BLUE}══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  Superpowers Plugin (Manual Installation Required)${NC}"
    echo -e "${BLUE}══════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${YELLOW}The superpowers plugin must be installed via Claude Code.${NC}"
    echo -e "${YELLOW}Run these commands in Claude Code:${NC}"
    echo ""
    echo -e "  ${GREEN}/plugin marketplace add superpowers-marketplace/superpowers${NC}"
    echo -e "  ${GREEN}/plugin install superpowers@superpowers-marketplace${NC}"
    echo ""
    echo -e "${BLUE}GitHub:${NC} https://github.com/obra/superpowers"
    echo ""
fi

# Handle google-ai-mode if needed
if [ "$ACTION_GOOGLE_AI_MODE" = "install" ]; then
    echo -e "${BLUE}══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  Installing Google AI Mode Skill${NC}"
    echo -e "${BLUE}══════════════════════════════════════════════════════════${NC}"
    echo ""

    mkdir -p "$HOME/.claude/skills"

    if [ -d "$HOME/.claude/skills/google-ai-mode/.git" ]; then
        echo -e "${YELLOW}Updating existing installation...${NC}"
        cd "$HOME/.claude/skills/google-ai-mode"
        git pull origin main 2>/dev/null || git pull origin master 2>/dev/null || echo "Could not pull updates"
    else
        # Remove any non-git directory that might exist
        rm -rf "$HOME/.claude/skills/google-ai-mode" 2>/dev/null || true
        echo -e "${YELLOW}Cloning from GitHub...${NC}"
        git clone https://github.com/PleasePrompto/google-ai-mode-skill.git "$HOME/.claude/skills/google-ai-mode"
    fi

    # Setup virtual environment for google-ai-mode
    echo -e "${YELLOW}Setting up Python environment...${NC}"
    cd "$HOME/.claude/skills/google-ai-mode"

    if [ ! -d ".venv" ]; then
        python3 -m venv .venv
    fi

    source .venv/bin/activate
    pip install -q -r requirements.txt 2>/dev/null || echo "Note: Some pip packages may have failed"
    deactivate

    echo -e "${GREEN}✓ Google AI Mode skill installed${NC}"
    echo ""
fi

# Handle deep-research-discovery if needed
if [ "$ACTION_DEEP_RESEARCH" = "install" ] || [ "$ACTION_DEEP_RESEARCH" = "update" ]; then
    if [ "$ACTION_DEEP_RESEARCH" = "update" ]; then
        echo -e "${BLUE}══════════════════════════════════════════════════════════${NC}"
        echo -e "${BLUE}  Updating Deep Research Discovery Skill${NC}"
        echo -e "${BLUE}══════════════════════════════════════════════════════════${NC}"
    else
        echo -e "${BLUE}══════════════════════════════════════════════════════════${NC}"
        echo -e "${BLUE}  Installing Deep Research Discovery Skill${NC}"
        echo -e "${BLUE}══════════════════════════════════════════════════════════${NC}"
    fi
    echo ""

    mkdir -p "$HOME/.claude/skills/deep-research-discovery"

    # Copy SKILL.md from the same directory as this script
    if [ -f "$SCRIPT_DIR/SKILL.md" ]; then
        cp "$SCRIPT_DIR/SKILL.md" "$HOME/.claude/skills/deep-research-discovery/"
        if [ "$ACTION_DEEP_RESEARCH" = "update" ]; then
            echo -e "${GREEN}✓ Deep Research Discovery skill updated${NC}"
        else
            echo -e "${GREEN}✓ Deep Research Discovery skill installed${NC}"
        fi
    else
        echo -e "${RED}✗ SKILL.md not found in $SCRIPT_DIR${NC}"
        echo -e "${YELLOW}Trying to download from GitHub...${NC}"
        curl -sL -o "$HOME/.claude/skills/deep-research-discovery/SKILL.md" \
            "https://raw.githubusercontent.com/HateBunnyPlzzz/deep-research-discovery-skill/main/SKILL.md"
        if [ -f "$HOME/.claude/skills/deep-research-discovery/SKILL.md" ]; then
            echo -e "${GREEN}✓ Deep Research Discovery skill downloaded from GitHub${NC}"
        else
            echo -e "${RED}✗ Failed to download skill${NC}"
            exit 1
        fi
    fi
    echo ""
fi

# Final status
echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                    Installation Complete                   ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

if [ "$ACTION_SUPERPOWERS" = "install" ]; then
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
echo "  1. Start a NEW Claude Code session (required to load skills)"
echo "  2. Type: /superpowers:brainstorming (to scope your research)"
echo "  3. Type: /deep-research-discovery (to start researching)"
echo ""
echo -e "${YELLOW}Important: You must start a NEW session for skills to be recognized!${NC}"
echo ""
echo -e "${BLUE}GitHub Repositories:${NC}"
echo "  - Superpowers: https://github.com/obra/superpowers"
echo "  - Google AI Mode: https://github.com/PleasePrompto/google-ai-mode-skill"
echo "  - Deep Research Discovery: https://github.com/HateBunnyPlzzz/deep-research-discovery-skill"
echo ""
