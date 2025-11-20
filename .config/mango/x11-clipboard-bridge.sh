#!/usr/bin/env bash
# Single wl-paste --watch handler:
#  - Prefer images (image/*) if available
#  - Otherwise, treat selection as text

set -euo pipefail

# Save the data that wl-paste piped to us
tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT
cat > "$tmp"

# Get all offered types for this selection
types="$(wl-paste --list-types)"

# 1) Prefer images if any image/* type exists
img_type="$(printf '%s\n' "$types" | grep '^image/' | head -n1 || true)"
if [ -n "$img_type" ]; then
  wl-paste --type "$img_type" | xclip -selection clipboard -t "$img_type" -in
  exit 0
fi

# 2) Fallback: just treat the original data as text
xclip -selection clipboard -in < "$tmp"
