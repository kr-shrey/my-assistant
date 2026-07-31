#!/usr/bin/env sh
# ==============================================================================
# install.sh — Installer & Manager for ai-framework-bootstrap meta-skill
# ==============================================================================
# Installs ai-framework-bootstrap globally into ~/.claude/skills/ or configures
# symlinks for auto-updating via git pull.
# ==============================================================================

set -e

SKILL_NAME="ai-framework-bootstrap"
CLAUDE_SKILLS_DIR="$HOME/.claude/skills"
TARGET_INSTALL_DIR="$CLAUDE_SKILLS_DIR/$SKILL_NAME"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_SKILL_DIR="$SCRIPT_DIR/.claude/skills/$SKILL_NAME"

MODE="copy"
UPGRADE=0

show_help() {
  cat << EOF
ai-framework-bootstrap Installer

Usage:
  ./install.sh [options]

Options:
  -s, --symlink    Symlink skill directory to ~/.claude/skills/ (recommended for dev & git pull updates)
  -c, --copy       Copy skill directory to ~/.claude/skills/ (standalone copy)
  -u, --upgrade    Upgrade existing installation in ~/.claude/skills/
  -h, --help       Show this help message

Examples:
  ./install.sh --symlink     # Symlink for auto-updates when repo is pulled
  ./install.sh --copy        # Copy files standalone
  curl -sSL https://raw.githubusercontent.com/krshrey/my-assistant/main/install.sh | sh
EOF
}

# Parse command line arguments
while [ "$#" -gt 0 ]; do
  case "$1" in
    -s|--symlink) MODE="symlink"; shift ;;
    -c|--copy) MODE="copy"; shift ;;
    -u|--upgrade) UPGRADE=1; shift ;;
    -h|--help) show_help; exit 0 ;;
    *) echo "Unknown option: $1"; show_help; exit 1 ;;
  esac
done

echo "==> Installing $SKILL_NAME meta-skill..."

# Ensure target skills directory exists
mkdir -p "$CLAUDE_SKILLS_DIR"

# Verify source skill directory exists
if [ ! -d "$SOURCE_SKILL_DIR" ]; then
  echo "Error: Source skill directory not found at $SOURCE_SKILL_DIR" >&2
  exit 1
fi

# Handle existing installation
if [ -e "$TARGET_INSTALL_DIR" ] || [ -L "$TARGET_INSTALL_DIR" ]; then
  if [ "$UPGRADE" = "1" ] || [ "$MODE" = "symlink" ] || [ "$MODE" = "copy" ]; then
    echo "  -> Removing previous installation at $TARGET_INSTALL_DIR"
    rm -rf "$TARGET_INSTALL_DIR"
  fi
fi

# Perform Installation
if [ "$MODE" = "symlink" ]; then
  echo "  -> Creating symlink: $TARGET_INSTALL_DIR -> $SOURCE_SKILL_DIR"
  ln -s "$SOURCE_SKILL_DIR" "$TARGET_INSTALL_DIR"
else
  echo "  -> Copying skill files to $TARGET_INSTALL_DIR"
  cp -R "$SOURCE_SKILL_DIR" "$TARGET_INSTALL_DIR"
fi

echo "==> Installation complete!"
echo ""
echo "The meta-skill is now available across your projects."
echo "Use '/ai-framework-bootstrap' in Claude Code or ask Gemini CLI to read the skill."
echo ""
