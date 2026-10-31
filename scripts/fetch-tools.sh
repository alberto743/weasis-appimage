#!/bin/bash
# SPDX-FileCopyrightText: 2026 Alberto P
# SPDX-License-Identifier: MPL-2.0
#
# Downloads the pinned AppImage build tools and verifies their SHA-256 (see tools.env).
#
# Usage: fetch-tools.sh <x86_64|aarch64> <dest-dir>

set -euo pipefail

ARCH="${1:?architecture is required (x86_64|aarch64)}"
DEST="${2:?destination directory is required}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

case "$ARCH" in
  x86_64 | aarch64) ;;
  *) echo "ERROR: unsupported architecture: $ARCH" >&2; exit 1 ;;
esac

# shellcheck source=../tools.env
. "$ROOT/tools.env"
mkdir -p "$DEST"

fetch() { # <file> <url> <sha256>
  curl -fsSL --retry 3 -o "$DEST/$1" "$2"
  echo "$3  $DEST/$1" | sha256sum -c -
  chmod +x "$DEST/$1"
}

sha_var() { # <prefix> -> value of <prefix>_<arch>
  local name="$1_$ARCH"
  echo "${!name}"
}

fetch "linuxdeploy-$ARCH.AppImage" \
  "https://github.com/linuxdeploy/linuxdeploy/releases/download/$LINUXDEPLOY_VERSION/linuxdeploy-$ARCH.AppImage" \
  "$(sha_var LINUXDEPLOY_SHA256)"
fetch "linuxdeploy-plugin-appimage-$ARCH.AppImage" \
  "https://github.com/linuxdeploy/linuxdeploy-plugin-appimage/releases/download/$LINUXDEPLOY_PLUGIN_VERSION/linuxdeploy-plugin-appimage-$ARCH.AppImage" \
  "$(sha_var LINUXDEPLOY_PLUGIN_SHA256)"
fetch "runtime-$ARCH" \
  "https://github.com/AppImage/type2-runtime/releases/download/$TYPE2_RUNTIME_VERSION/runtime-$ARCH" \
  "$(sha_var TYPE2_RUNTIME_SHA256)"
