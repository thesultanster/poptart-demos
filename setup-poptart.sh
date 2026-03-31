#!/bin/bash

# ============================================================
#  Poptart Setup
#  Double-click this file to set up your prototyping environment
# ============================================================

set -e

BOLD="\033[1m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
CYAN="\033[0;36m"
RESET="\033[0m"

CHECKMARK="${GREEN}✓${RESET}"
ARROW="${CYAN}→${RESET}"

clear

echo ""
echo -e "${BOLD}    ____              __             __  ${RESET}"
echo -e "${BOLD}   / __ \\____  ____  / /_____ ______/ /_ ${RESET}"
echo -e "${BOLD}  / /_/ / __ \\/ __ \\/ __/ __ \`/ ___/ __/ ${RESET}"
echo -e "${BOLD} / ____/ /_/ / /_/ / /_/ /_/ / /  / /_   ${RESET}"
echo -e "${BOLD}/_/    \\____/ .___/\\__/\\__,_/_/   \\__/   ${RESET}"
echo -e "${BOLD}           /_/                            ${RESET}"
echo ""
echo -e "  ${BOLD}Prototype Setup${RESET}"
echo -e "  This will install everything you need to build prototypes."
echo ""
echo -e "  ${YELLOW}You may be asked for your Mac password during setup.${RESET}"
echo ""
read -p "  Press Enter to start..."
echo ""

# ----------------------------------------------------------
#  Step 1: Homebrew
# ----------------------------------------------------------
echo -e "  ${ARROW} ${BOLD}Step 1/6: Homebrew${RESET} (package manager)"

if command -v brew &>/dev/null; then
  echo -e "  ${CHECKMARK} Homebrew already installed"
else
  echo -e "  Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  fi

  echo -e "  ${CHECKMARK} Homebrew installed"
fi
echo ""

# ----------------------------------------------------------
#  Step 2: Git
# ----------------------------------------------------------
echo -e "  ${ARROW} ${BOLD}Step 2/6: Git${RESET} (version control)"

if command -v git &>/dev/null; then
  echo -e "  ${CHECKMARK} Git already installed"
else
  echo -e "  Installing Git..."
  brew install git
  echo -e "  ${CHECKMARK} Git installed"
fi
echo ""

# ----------------------------------------------------------
#  Step 3: GitHub CLI
# ----------------------------------------------------------
echo -e "  ${ARROW} ${BOLD}Step 3/6: GitHub CLI${RESET} (authenticate with GitHub)"

if command -v gh &>/dev/null; then
  echo -e "  ${CHECKMARK} GitHub CLI already installed"
else
  echo -e "  Installing GitHub CLI..."
  brew install gh
  echo -e "  ${CHECKMARK} GitHub CLI installed"
fi

if ! gh auth status &>/dev/null 2>&1; then
  echo ""
  echo -e "  ${YELLOW}You need to log into GitHub. A browser window will open.${RESET}"
  echo -e "  ${YELLOW}Select your Hungryroot GitHub account.${RESET}"
  echo ""
  read -p "  Press Enter to open GitHub login..."
  gh auth login --web --git-protocol https
  echo -e "  ${CHECKMARK} Logged into GitHub"
else
  echo -e "  ${CHECKMARK} Already logged into GitHub"
fi
echo ""

# ----------------------------------------------------------
#  Step 4: Node.js
# ----------------------------------------------------------
echo -e "  ${ARROW} ${BOLD}Step 4/6: Node.js${RESET} (JavaScript runtime)"

if command -v node &>/dev/null; then
  echo -e "  ${CHECKMARK} Node.js already installed ($(node --version))"
else
  echo -e "  Installing Node.js..."
  brew install node
  echo -e "  ${CHECKMARK} Node.js installed ($(node --version))"
fi
echo ""

# ----------------------------------------------------------
#  Step 5: Clone Poptart
# ----------------------------------------------------------
echo -e "  ${ARROW} ${BOLD}Step 5/6: Poptart repo${RESET}"

POPTART_DIR="$HOME/Workspaces/poptart"

if [ -d "$POPTART_DIR" ]; then
  echo -e "  ${CHECKMARK} Poptart already cloned at $POPTART_DIR"
  cd "$POPTART_DIR"
  echo -e "  Pulling latest changes..."
  git pull origin main 2>/dev/null || true
else
  echo -e "  Cloning Poptart repo..."
  mkdir -p "$HOME/Workspaces"
  gh repo clone hungryroot/poptart "$POPTART_DIR"
  cd "$POPTART_DIR"
  echo -e "  ${CHECKMARK} Poptart cloned to $POPTART_DIR"
fi

echo -e "  Installing dependencies..."
npm install
echo -e "  ${CHECKMARK} Dependencies installed"
echo ""

# ----------------------------------------------------------
#  Step 6: Claude Code
# ----------------------------------------------------------
echo -e "  ${ARROW} ${BOLD}Step 6/6: Claude Code${RESET} (AI coding assistant)"

if command -v claude &>/dev/null; then
  echo -e "  ${CHECKMARK} Claude Code already installed"
else
  echo -e "  Installing Claude Code..."
  npm install -g @anthropic-ai/claude-code
  echo -e "  ${CHECKMARK} Claude Code installed"
fi
echo ""

# ----------------------------------------------------------
#  Done
# ----------------------------------------------------------
echo ""
echo -e "  ${GREEN}${BOLD}Setup complete!${RESET}"
echo ""
echo -e "  ${BOLD}What's next:${RESET}"
echo ""
echo -e "  1. Start the dev server:"
echo -e "     ${CYAN}cd ~/Workspaces/poptart && npm run dev${RESET}"
echo ""
echo -e "  2. Open a new Terminal tab (Cmd+T) and start Claude Code:"
echo -e "     ${CYAN}cd ~/Workspaces/poptart && claude${RESET}"
echo ""
echo -e "  3. Tell Claude what to build:"
echo -e "     ${CYAN}\"Create a new prototype with a recipe card grid\"${RESET}"
echo ""
echo -e "  Questions? Post in ${BOLD}#prototyper-community${RESET} on Slack"
echo ""
read -p "  Press Enter to close..."
