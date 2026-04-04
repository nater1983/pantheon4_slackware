#!/bin/bash

# ------------------------------------------
# Pantheon + Dependencies Source Tarball Generator
# (Slackware-friendly, no .SlackBuild updates)
# ------------------------------------------

set -euo pipefail

ROOT_DIR="$(pwd)"
GITHUB_BASE_URL="https://github.com/elementary"
DEST_DIR="src"

mkdir -p "$DEST_DIR"

# Check for required tools
for cmd in git lzip tar; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "❌ Required tool not found: $cmd"
    exit 1
  fi
done

# -------------------------------
# 1. Pantheon Core Components
# -------------------------------
declare -A CORE_REPOS=(
  ["default-settings"]="default-settings"
  ["granite"]="granite"
  ["gala"]="gala"
  ["greeter"]="greeter"
  ["dock"]="dock"
  ["sideload"]="sideload"
  ["pantheon-wayland"]="pantheon-wayland"
  ["portals"]="portals"
  ["switchboard"]="switchboard"
  ["session-settings"]="session-settings"
  ["settings-applications"]="settings-applications"
  ["settings-bluetooth"]="settings-bluetooth"
  ["settings-datetime"]="settings-datetime"
  ["settings-daemon"]="settings-daemon"
  ["settings-display"]="settings-display"
  ["settings-keyboard"]="settings-keyboard"
  ["settings-locale"]="settings-locale"
  ["settings-mouse-touchpad"]="settings-mouse-touchpad"
  ["settings-network"]="settings-network"
  ["settings-notifications"]="settings-notifications"
  ["settings-desktop"]="settings-desktop"
  ["settings-onlineaccounts"]="settings-onlineaccounts"
  ["settings-power"]="settings-power"
  ["settings-printers"]="settings-printers"
  ["settings-screentime-limits"]="settings-screentime-limits"
  ["settings-security-privacy"]="settings-security-privacy"
  ["settings-sharing"]="settings-sharing"
  ["settings-sound"]="settings-sound"
  ["settings-system"]="settings-system"
  ["settings-useraccounts"]="settings-useraccounts"
  ["settings-wacom"]="settings-wacom"
  ["stylesheet"]="stylesheet"
  ["wingpanel"]="wingpanel"
  ["panel-applications"]="applications-menu"
  ["panel-bluetooth"]="panel-bluetooth"
  ["panel-datetime"]="panel-datetime"
  ["panel-keyboard"]="panel-keyboard"
  ["panel-network"]="wingpanel-indicator-network"
  ["panel-nightlight"]="panel-nightlight"
  ["panel-notifications"]="wingpanel-indicator-notifications"
  ["panel-power"]="panel-power"
  ["panel-settings"]="quick-settings"
  ["panel-sound"]="wingpanel-indicator-sound"
)

# -------------------------------
# 2. Pantheon Applications
# -------------------------------
declare -A APPS_REPOS=(
  ["appcenter"]="appcenter"
  ["calendar"]="calendar"
  ["calculator"]="calculator"
  ["camera"]="camera"
  ["code"]="code"
  ["files"]="files"
  ["icons"]="icons"
  ["livechart"]="live-chart"
  ["mail"]="mail"
  ["monitor"]="monitor"
  ["music"]="music"
  ["onboarding"]="onboarding"
  ["pantheon-agent-polkit"]="pantheon-agent-polkit"
  ["photos"]="photos"
  ["screenshot"]="screenshot"
  ["tasks"]="tasks"
  ["terminal"]="terminal"
  ["videos"]="videos"
)

# -------------------------------
# 3. Pantheon Dependencies
# -------------------------------
declare -A EXTRA_REPOS=(
  ["contractor"]="contractor"
  ["notifications"]="notifications"
  ["print"]="print"
)

# -------------------------------
# Internal function to process repositories
# -------------------------------
process_repo() {
  local PRGNAM="$1"
  local REPO_NAME="$2"

  echo "→ Processing $REPO_NAME..."

  local GITDIR
  GITDIR=$(mktemp -d "$ROOT_DIR/${PRGNAM}.XXXXXX")

  git clone --depth 1 "$GITHUB_BASE_URL/$REPO_NAME.git" "$GITDIR" || {
    echo "❌ Failed to clone $REPO_NAME"
    rm -rf "$GITDIR"
    return 1
  }

  # Fetch all tags with depth 1 so shallow clone can resolve them
  git -C "$GITDIR" fetch --tags --depth 1 --quiet || true

  local VERSION
  local latest_tag
  # Sort tags semantically descending, take the top one
  latest_tag=$(git -C "$GITDIR" tag --sort=-version:refname | head -n1)

  if [ -n "$latest_tag" ]; then
    VERSION=$(echo "$latest_tag" | sed 's/^v//; s/-/./g')
  else
    # No tags found — fall back to date.hash
    VERSION=$(git -C "$GITDIR" log --date=format:%Y%m%d --pretty=format:%cd.%h -n1)
  fi

  # Strip known distro suffixes
  VERSION=$(echo "$VERSION" | sed -E 's/\.(debian|ubuntu|fedora|arch|opensuse)//g')

  local _commit
  _commit=$(git -C "$GITDIR" rev-parse HEAD)

  echo "   VERSION: $VERSION"
  echo "   COMMIT : $_commit"

  # Remove VCS and CI metadata
  rm -rf \
    "$GITDIR/.git" \
    "$GITDIR/.github" \
    "$GITDIR/.gitmodules"
  find "$GITDIR" -name '.gitignore' -delete

  local STAGE_DIR="$ROOT_DIR/${PRGNAM}-${VERSION}"
  local TARBALL="$DEST_DIR/${PRGNAM}-${VERSION}.tar.lz"

  mv "$GITDIR" "$STAGE_DIR"

  tar --lzip -cf "$TARBALL" -C "$ROOT_DIR" "${PRGNAM}-${VERSION}"
  rm -rf "$STAGE_DIR"

  echo "✅ Created: $TARBALL"
}

# -------------------------------
# Process everything
# -------------------------------
echo "=== Processing Core Components ==="
for PRGNAM in "${!CORE_REPOS[@]}"; do
  process_repo "$PRGNAM" "${CORE_REPOS[$PRGNAM]}"
done

echo "=== Processing Applications ==="
for PRGNAM in "${!APPS_REPOS[@]}"; do
  process_repo "$PRGNAM" "${APPS_REPOS[$PRGNAM]}"
done

echo "=== Processing Dependencies ==="
for PRGNAM in "${!EXTRA_REPOS[@]}"; do
  process_repo "$PRGNAM" "${EXTRA_REPOS[$PRGNAM]}"
done

echo ""
echo "🎉 All repositories processed. Tarballs available at: $DEST_DIR"
