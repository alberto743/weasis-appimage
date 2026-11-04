#!/bin/bash
# SPDX-FileCopyrightText: 2026 Alberto P
# SPDX-License-Identifier: MPL-2.0
#
# Bumps the pinned build tools in tools.env to their newest upstream release and recomputes the SHA-256.
# Prints one line per bumped tool and nothing else when everything is current.
# GH_TOKEN is optional (it only raises the GitHub API rate limit).

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="$ROOT/tools.env"
ARCHES=(x86_64 aarch64)
EMPTY_SHA256=e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855

api() {
  curl -fsSL --retry 3 ${GH_TOKEN:+-H "Authorization: Bearer $GH_TOKEN"} "https://api.github.com/$1"
}

current() { # <variable> -> value in tools.env
  sed -n "s/^$1=//p" "$ENV_FILE"
}

set_var() { # <variable> <value>
  sed -i "s|^$1=.*|$1=$2|" "$ENV_FILE"
}

asset_sha256() { # <repo> <tag> <asset>: the digest GitHub records, else the hash of the download
  local digest
  digest=$(api "repos/$1/releases/tags/$2" | jq -r --arg n "$3" '.assets[] | select(.name == $n) | .digest // empty')
  if [ -n "$digest" ]; then
    echo "${digest#sha256:}"
  else
    curl -fsSL --retry 3 "https://github.com/$1/releases/download/$2/$3" | sha256sum | cut -d' ' -f1
  fi
}

bump() { # <prefix> <repo> <asset template with @ARCH@>
  local prefix="$1" repo="$2" template="$3" tag arch asset sha
  # Newest non-draft release. Alpha pre-releases are accepted, but the rolling "continuous" tag is skipped:
  # its assets change in place, so a pinned SHA-256 would stop matching.
  tag=$(api "repos/$repo/releases?per_page=20" \
    | jq -r '[.[] | select((.draft | not) and .tag_name != "continuous")][0].tag_name // empty')
  if [ -z "$tag" ]; then
    echo "ERROR: no release found for $repo" >&2
    exit 1
  fi
  [ "$tag" != "$(current "${prefix}_VERSION")" ] || return 0

  for arch in "${ARCHES[@]}"; do
    asset="${template//@ARCH@/$arch}"
    # Assign first: a failure inside "$(...)" as a command argument would be swallowed
    sha=$(asset_sha256 "$repo" "$tag" "$asset")
    if ! [[ "$sha" =~ ^[0-9a-f]{64}$ ]] || [ "$sha" = "$EMPTY_SHA256" ]; then
      echo "ERROR: no valid SHA-256 for $asset in $repo $tag" >&2
      exit 1
    fi
    set_var "${prefix}_SHA256_$arch" "$sha"
  done
  echo "$repo: $(current "${prefix}_VERSION") -> $tag"
  set_var "${prefix}_VERSION" "$tag"
}

bump LINUXDEPLOY linuxdeploy/linuxdeploy "linuxdeploy-@ARCH@.AppImage"
bump LINUXDEPLOY_PLUGIN linuxdeploy/linuxdeploy-plugin-appimage "linuxdeploy-plugin-appimage-@ARCH@.AppImage"
bump TYPE2_RUNTIME AppImage/type2-runtime "runtime-@ARCH@"
