#!/bin/bash

# ------------------------------------------
# Pantheon + Dependencies Source Tarball Generator
# (Slackware-friendly, no .SlackBuild updates)
# ------------------------------------------

set -e

ROOT_DIR="$(pwd)"
GITHUB_BASE_URL="https://github.com/elementary"
DEST_DIR="src"

mkdir -p "$DEST_DIR"

# -------------------------------
# 1. Pantheon Core Components
# -------------------------------
declare -A CORE_REPOS=(
  ["granite"]="granite"
  ["gala"]="gala"
  ["greeter"]="greeter"
  ["pantheon-shell"]="session-settings"
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
  ["contractor"]="contractor"                       # extension service for menu/context integration :contentReference[oaicite:4]{index=4}
  ["notifications"]="notifications"                 # GTK notifications server :contentReference[oaicite:5]{index=5}
  ["print"]="print"                                 # simple shim for printing support via Contractor :contentReference[oaicite:7]{index=7}
)

# -------------------------------
# Internal function to process repositories
# -------------------------------
process_repo() {
  local PRGNAM=$1
  local REPO_NAME=$2

  echo "→ Processing $REPO_NAME..."

  local GITDIR
  GITDIR=$(mktemp -dt "$PRGNAM.git.XXXXXX")
  git clone --depth 1 "$GITHUB_BASE_URL/$REPO_NAME.git" "$GITDIR" || {
    echo "❌ Failed to clone $REPO_NAME"
    return 1
  }

  cd "$GITDIR"
  git fetch --tags || true

  local VERSION
  VERSION=$(git describe --tags "$(git rev-list --tags --max-count=1)" 2>/dev/null || true)
  if [ -z "$VERSION" ]; then
    VERSION=$(git log --date=format:%Y%m%d --pretty=format:%cd.%h -n1)
  else
    VERSION=$(echo "$VERSION" | sed 's/^v//; s/-/./g')
  fi

  # Strip distro suffixes from version name (e.g., .debian, .ubuntu, .fedora, etc.)
  VERSION=$(echo "$VERSION" | sed -E 's/(\.debian|\.ubuntu|\.fedora|\.arch|\.opensuse)//g')

  local _commit
  _commit=$(git rev-parse HEAD)

  echo "   VERSION: $VERSION"
  echo "   COMMIT : $_commit"

  # Clean up
  rm -rf .git
  find . -name .gitignore -print0 | xargs -0 rm -f

  cd "$ROOT_DIR"

  # Create tarball
  mv "$GITDIR" "$PRGNAM-$VERSION"
  tar --lzip -cvf "$PRGNAM-$VERSION.tar.lz" "$PRGNAM-$VERSION"
  rm -rf "$PRGNAM-$VERSION"
  mv -f "$PRGNAM-$VERSION.tar.lz" "$DEST_DIR"

  echo "✅ Created: $DEST_DIR/$PRGNAM-$VERSION.tar.lz"
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

echo "🎉 All repositories processed. Tarballs available at:"
echo "   $DEST_DIR"

