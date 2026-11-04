#!/bin/bash
# SPDX-FileCopyrightText: 2026 Alberto P
# SPDX-License-Identifier: MPL-2.0
#
# Repackages the upstream Weasis .deb (jpackage output) as an AppImage with linuxdeploy.
#
# Usage: package-appimage.sh --deb <file.deb> --arch x86_64|aarch64 --out <dir> --tools <dir>
#                            [--update-info <zsync-update-information>]
# <dir> for --tools is filled by fetch-tools.sh.
# Besides the AppImage, <out> receives a tarball with the repo notices, the vendored license texts,
# the license/notice files of the .deb and of every bundled jar (including nested ones), and the
# Java runtime build information.

set -euo pipefail

die() {
  echo "ERROR: $*" >&2
  exit 1
}

UPDATE_INFO=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --deb | --arch | --out | --tools | --update-info)
      [[ $# -ge 2 ]] || die "$1 requires a value"
      case "$1" in
        --deb) DEB="$2" ;;
        --arch) ARCH="$2" ;;
        --out) OUT="$2" ;;
        --tools) TOOLS="$2" ;;
        --update-info) UPDATE_INFO="$2" ;;
      esac
      shift 2 ;;
    *) die "Unknown option: $1" ;;
  esac
done
: "${DEB:?--deb is required}" "${ARCH:?--arch is required}" "${OUT:?--out is required}" "${TOOLS:?--tools is required}"

case "$ARCH" in
  x86_64 | aarch64) ;;
  *) die "Unsupported architecture: $ARCH" ;;
esac

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
[ -f "$DEB" ] || die "$DEB not found"
[ -d "$TOOLS" ] || die "tools directory $TOOLS not found"
TOOLS=$(cd "$TOOLS" && pwd)
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT
APPDIR="$WORK/AppDir"
VERSION=$(dpkg-deb -f "$DEB" Version | cut -d- -f1)

dpkg-deb -x "$DEB" "$WORK/deb"
APP="$WORK/deb/opt/weasis"
[ -x "$APP/bin/Weasis" ] || die "bin/Weasis not found in $DEB"

# Relative Exec/Icon: the AppImage is relocatable, unlike the /opt/weasis paths of the deb.
# The weasis:// handler is declared but only becomes active once an integration tool installs the entry.
[ -f "$APP/lib/weasis-Weasis.desktop" ] || die "lib/weasis-Weasis.desktop not found in $DEB"
[ -f "$APP/lib/Weasis.png" ] || die "lib/Weasis.png not found in $DEB"
sed -e 's|^Exec=.*|Exec=Weasis %U|' -e 's|^Icon=.*|Icon=weasis|' \
  "$APP/lib/weasis-Weasis.desktop" > "$WORK/weasis.desktop"
if ! grep -q '^MimeType=.*x-scheme-handler/weasis;' "$WORK/weasis.desktop"; then
  if grep -q '^MimeType=' "$WORK/weasis.desktop"; then
    sed -i '/^MimeType=/ s|;*$|;x-scheme-handler/weasis;|' "$WORK/weasis.desktop"
  else
    echo 'MimeType=x-scheme-handler/weasis;' >> "$WORK/weasis.desktop"
  fi
fi
cp "$APP/lib/Weasis.png" "$WORK/weasis.png"
if command -v desktop-file-validate >/dev/null; then
  desktop-file-validate "$WORK/weasis.desktop" || die "invalid desktop file"
fi

export APPIMAGE_EXTRACT_AND_RUN=1 ARCH
export LDAI_RUNTIME_FILE="$TOOLS/runtime-$ARCH"
[ -z "$UPDATE_INFO" ] || export LDAI_UPDATE_INFORMATION="$UPDATE_INFO"
mkdir -p "$OUT" "$APPDIR/usr/bin"
OUT=$(cd "$OUT" && pwd)
export OUTPUT="$OUT/Weasis-$VERSION-$ARCH.AppImage"

# Stage 1 uses a placeholder launcher: linuxdeploy fails when it scans the bundled JRE (libjvm.so)
printf '#!/bin/sh\n' > "$APPDIR/usr/bin/Weasis"
chmod +x "$APPDIR/usr/bin/Weasis"
"$TOOLS/linuxdeploy-$ARCH.AppImage" --appdir "$APPDIR" -d "$WORK/weasis.desktop" -i "$WORK/weasis.png"

# Stage 2: the real jpackage tree replaces the placeholder, then the AppDir is packed
cp -a "$APP/." "$APPDIR/usr/"
ln -sfn usr/bin/Weasis "$APPDIR/AppRun"
# Ship the notices inside the image too, so a copied AppImage still carries them
mkdir -p "$APPDIR/usr/share/doc/weasis-appimage"
cp "$ROOT/THIRD-PARTY-NOTICES.md" "$APPDIR/usr/share/doc/weasis-appimage/"
# The plugin writes the .zsync file to the current directory
(cd "$OUT" && "$TOOLS/linuxdeploy-plugin-appimage-$ARCH.AppImage" --appdir "$APPDIR")

# Notices shipped with the release: repo notices, vendored license texts, the license/notice files of
# the .deb and of the (xz-compressed, possibly nested) bundled jars, and the Java runtime build
unzip_entries() { # <jar> <dest> <pattern>...: unzip drops entries that would escape <dest>; exit 11 = no match
  local jar="$1" dest="$2" rc=0 log
  shift 2
  mkdir -p "$dest"
  log=$(unzip -q -o -C "$jar" "$@" -d "$dest" 2>&1) || rc=$?
  # 0 = ok, 1 = warnings only, 11 = no match
  if [ "$rc" -ne 0 ] && [ "$rc" -ne 1 ] && [ "$rc" -ne 11 ]; then
    echo "$log" >&2
    die "unzip failed ($rc) on $jar"
  fi
}

extract_licenses() { # <jar> <dest>
  unzip_entries "$1" "$2" 'META-INF/LICENSE*' 'META-INF/NOTICE*' 'META-INF/COPYING*' \
    'META-INF/DEPENDENCIES*' 'META-INF/license/*' 'LICENSE*' 'NOTICE*' 'COPYING*'
}

extract_nested_jars() { # <jar> <dest>: inner jars under lib/ (OSGi Bundle-ClassPath)
  unzip_entries "$1" "$2" 'lib/*.jar'
}

NOTICE_DIR="$WORK/notices"
mkdir -p "$NOTICE_DIR/deb" "$NOTICE_DIR/jars"
cp "$ROOT/THIRD-PARTY-NOTICES.md" "$NOTICE_DIR/"
cp -a "$ROOT/third-party-licenses" "$NOTICE_DIR/"
(cd "$WORK/deb" && find . -type f \( -iname 'LICENSE*' -o -iname 'LICENCE*' -o -iname 'NOTICE*' \
  -o -iname 'COPYING*' -o -iname 'THIRD*PARTY*' -o -iname 'copyright' -o -path '*/runtime/release' \) \
  -exec cp --parents {} "$NOTICE_DIR/deb/" \;)
# The runtime's full legal tree (GPL text, Classpath Exception, assembly exception, per-module notices)
[ ! -d "$APP/lib/runtime/legal" ] || cp -a "$APP/lib/runtime/legal" "$NOTICE_DIR/runtime-legal"
for xz in "$APP"/lib/app/bundle/*.jar.xz "$APP"/lib/app/bundle-i18n/*.jar.xz; do
  [ -e "$xz" ] || continue
  name=$(basename "$xz" .jar.xz)
  xz -dc "$xz" > "$WORK/$name.jar"
  extract_licenses "$WORK/$name.jar" "$NOTICE_DIR/jars/$name"
  nested="$WORK/nested/$name"
  extract_nested_jars "$WORK/$name.jar" "$nested"
  for inner in "$nested"/lib/*.jar; do
    [ -e "$inner" ] || continue
    extract_licenses "$inner" "$NOTICE_DIR/jars/$name/$(basename "$inner" .jar)"
  done
  rm -rf "$WORK/$name.jar" "$nested"
done
find "$NOTICE_DIR/jars" -type d -empty -delete
NOTICES="$OUT/Weasis-$VERSION-$ARCH.licenses.tar.gz"
tar -C "$NOTICE_DIR" -czf "$NOTICES" .

echo "Created $OUTPUT"
echo "Created $NOTICES"
